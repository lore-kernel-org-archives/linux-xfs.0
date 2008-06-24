Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 17:10:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O0ANkR028885
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 17:10:33 -0700
Date: Tue, 24 Jun 2008 10:11:55 +1000
Subject: Re: REVIEW: Fix CI lookup in leaf-form directories
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.uc6088qm3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080623093718.GA21251@infradead.org>
Message-ID: <op.uc7755fr3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080623093718.GA21251@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 23 Jun 2008 19:37:18 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Mon, Jun 23, 2008 at 06:44:58PM +1000, Barry Naujok wrote:
>> Along the same lines as the node-form directory patch last week,
>> the leaf-form is not handling directory buffers properly and
>> locks up.
>>
>> Instead of comparing buffer pointers, compare buffer block numbers
>> and don't keep buffers hanging around.
>
> Which might be a small performance penalty, but I think that's fine
> for the CI lookup case.

The worst case performance hit is one extra read when there is a CI
match where the data entry in is a different block to the last
hash value in the leaf.

> The patch looks good to me.
>
> But one things in the original xfs_dir2_leaf_lookup_int that barely
> touched by your patch really irks me:
>
>> -	cbp = NULL;
>> -	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1;
>> +	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1, cidb = -1;
>>  				index < be16_to_cpu(leaf->hdr.count) &&
>>  				be32_to_cpu(lep->hashval) == args->hashval;
>>  				lep++, index++) {
>
> I'd really prefer to have not too much rather unrelated bits in the
> for loop.  In fact the use of the for construct here is more than odd
> because there is no such things as a loop variable at all.  I think
> we'd be much better of in terms of readability with a simple while
> loop with where all the initialization is moved out of the loop.
>
> Probably not for this patch, though..

Too late :)

--- a/fs/xfs/xfs_dir2_leaf.c	2008-06-24 10:09:38.000000000 +1000
+++ b/fs/xfs/xfs_dir2_leaf.c	2008-06-24 10:07:30.382990266 +1000
@@ -1321,8 +1321,8 @@ xfs_dir2_leaf_lookup_int(
  	int			*indexp,	/* out: index in leaf block */
  	xfs_dabuf_t		**dbpp)		/* out: data buffer */
  {
-	xfs_dir2_db_t		curdb;		/* current data block number */
-	xfs_dabuf_t		*dbp;		/* data buffer */
+	xfs_dir2_db_t		curdb = -1;	/* current data block number */
+	xfs_dabuf_t		*dbp = NULL;	/* data buffer */
  	xfs_dir2_data_entry_t	*dep;		/* data entry */
  	xfs_inode_t		*dp;		/* incore directory inode */
  	int			error;		/* error return code */
@@ -1333,7 +1333,7 @@ xfs_dir2_leaf_lookup_int(
  	xfs_mount_t		*mp;		/* filesystem mount point */
  	xfs_dir2_db_t		newdb;		/* new data block number */
  	xfs_trans_t		*tp;		/* transaction pointer */
-	xfs_dabuf_t		*cbp;		/* case match data buffer */
+	xfs_dir2_db_t		cidb = -1;	/* case match data block no. */
  	enum xfs_dacmp		cmp;		/* name compare result */

  	dp = args->dp;
@@ -1358,9 +1357,7 @@ xfs_dir2_leaf_lookup_int(
  	 * Loop over all the entries with the right hash value
  	 * looking to match the name.
  	 */
-	cbp = NULL;
-	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1;
-				index < be16_to_cpu(leaf->hdr.count) &&
+	for (lep = &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
  				be32_to_cpu(lep->hashval) == args->hashval;
  				lep++, index++) {
  		/*

...
