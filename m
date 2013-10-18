Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE3767F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 08:22:27 -0500 (CDT)
Message-ID: <52613610.5090409@sgi.com>
Date: Fri, 18 Oct 2013 08:22:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/4] xfsprogs: v4 inode type in directory
References: <20131017152804.204045257@sgi.com> <52605FF8.2000301@sgi.com>
	<20131018031950.GT4446@dastard>
In-Reply-To: <20131018031950.GT4446@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/17/13 22:19, Dave Chinner wrote:
> On Thu, Oct 17, 2013 at 05:08:56PM -0500, Mark Tinguely wrote:
>> On 10/17/13 10:28, Mark Tinguely wrote:
>>> Here are the patches that enable the inode in the directory
>>> feature in v4 superblocks.
>>>
>>> Unchanged
>>>   patch 1: add the entries to xfs_sb.h (sync with kernel)
>>>   patch 2: add the XFS_FSOP_GEOM_FLAGS_FTYPE to xfs_fs.h (sync with kernel)
>>> 	  add the entry to repair so that xfs_info reports the feature
>>> New
>>>   patch 3: add feature to the xfs_db version command.
>>>
>>> Fixed
>>>   patch 4: add the feature to mkfs.xfs and manual page.
>>>            note: this new feature is ignored for superblock v5
>>> 		automatically turns on this feature.
>>
>> FYI.
>>
>> I saw the request for adding the filetype entry to block/leaf after posting.
>>
>> I have it displaying unconditionally, but am trying to figure out
>> how to make it display only for filesytems that support the ftype
>> feature. I am missing something in the field.count().
>
> The count function only tells the code whether a structure is
> present or not, but it does not tell you what the format of the
> structure is.
>
> if you look at db/dir2.c, you'll see that the difference between the
> dir2_flds[] and the dir3_flds[] is mainly in the type, count and offset
> fields. For example:
>
> const field_t   dir2_flds[] = {
>          { "bhdr", FLDT_DIR2_DATA_HDR, OI(BOFF(magic)), dir2_block_hdr_count,
>            FLD_COUNT, TYP_NONE }
> ...
>
> const field_t   dir3_flds[] = {
>          { "bhdr", FLDT_DIR3_DATA_HDR, OI(B3OFF(hdr)), dir3_block_hdr_count,
>            FLD_COUNT, TYP_NONE },
> ...
>
> if you look at dir[23]_block_hdr_count(), you'll see that they
> return a boolean value based on a magic number check. Hence when the
> code is trying to determine the type of the block that has been read
> (i.e. what the field definition is), if the magic number matches we
> know exactly what type of contents they contain.
>
> For decoding the dtype, you need too look at how to select the
> correct structure for the FLDT_DIR2_DATA_UNION. If you don't have
> the feature set, you need to select the FLDT_DIR2_DATA_UNION
> structure type, and if it is set you need to select the
> FLDT_DIR3_DATA_UNION type. Hence you need both these types defined
> in the dir2_flds[] array, and some manner to ensure the correct
> values are returned from the count functions.
>
> And just to make it hard, both the dir2 and dir3 data union count
> functions use the same function (dir2_data_u_count) so you're going
> to have to be careful that you don't break the v5 superblock
> directory decoding....
>
> Cheers,
>
> Dave.


Thanks Dave. I did some RTFS and found I was having problems with the 
field_t.flag.

Can't we add a filetype to the dir2 dir2_data_union_flds entry and use 
the count to turn it on/off? The problem I was having with this was the 
flag. Something like:

Add the directory field type information to xfs_db directory
displays.

---
  db/dir2.c |   12 ++++++++++++
  1 file changed, 12 insertions(+)

Index: b/db/dir2.c
===================================================================
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -52,6 +52,8 @@ static int	dir2_leaf_tail_count(void *ob
  static int	dir2_leaf_tail_offset(void *obj, int startoff, int idx);
  static int	dir2_node_btree_count(void *obj, int startoff);
  static int	dir2_node_hdr_count(void *obj, int startoff);
+static int	dir3_data_union_ftype_offset(void *obj, int startoff, int idx);
+static int	dir2_data_union_ftype_count(void *obj, int startoff);

  const field_t	dir2_hfld[] = {
  	{ "", FLDT_DIR2, OI(0), C1, 0, TYP_NONE },
@@ -130,6 +132,8 @@ const field_t	dir2_data_union_flds[] = {
  	  dir2_data_union_namelen_count, FLD_COUNT, TYP_NONE },
  	{ "name", FLDT_CHARNS, OI(DEOFF(name)), dir2_data_union_name_count,
  	  FLD_COUNT, TYP_NONE },
+	{ "filetype", FLDT_UINT8D, dir3_data_union_ftype_offset,
+	  dir2_data_union_ftype_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
  	{ "tag", FLDT_DIR2_DATA_OFF, dir2_data_union_tag_offset,
  	  dir2_data_union_tag_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
  	{ NULL }
@@ -454,6 +458,14 @@ dir2_data_union_name_count(
  }

  static int
+dir2_data_union_ftype_count(
+	void			*obj,
+	int			startoff)
+{
+	return xfs_sb_version_hasftype(&mp->m_sb);
+}
+
+static int
  dir2_data_union_namelen_count(
  	void			*obj,
  	int			startoff)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
