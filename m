Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D2C07F37
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 15:11:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BA9C304048
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 13:11:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TxlJEP1WMTecNyCq for <xfs@oss.sgi.com>;
	Mon, 14 Sep 2015 13:11:25 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5427263CBCF5
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 15:11:25 -0500 (CDT)
Subject: Re: [PATCH 13/13] xfs_repair: Fix up warning strings in da_util.c
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<1441827251-13128-14-git-send-email-sandeen@sandeen.net>
	<20150914200617.GM34083@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55F729EB.2090605@sandeen.net>
Date: Mon, 14 Sep 2015 15:11:23 -0500
MIME-Version: 1.0
In-Reply-To: <20150914200617.GM34083@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 9/14/15 3:06 PM, Brian Foster wrote:
> On Wed, Sep 09, 2015 at 02:34:11PM -0500, Eric Sandeen wrote:
>> Switch the warning messages based on which fork has
>> encountered the problem.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
> 
> I assume this is being reworked based on the discussion with Carlos (and
> I'm really not familiar with the localization stuff). That aside,
> shouldn't this be ordered at some point before these functions are
> called from both directory and attribute contexts so the messages aren't
> ever incorrect?

Well, tradeoffs I guess.  I ordered it to make review easy.  If we think
message correctness is a bisectability issue, I could rework it so that
it's always correct, but it didn't seem like that big a deal to me.

> Also, one nit below...
> 
>>  repair/attr_repair.c |    2 +-
>>  repair/da_util.c     |   97 +++++++++++++++++++++++++++-----------------------
>>  repair/da_util.h     |    3 +-
>>  repair/dir2.c        |    2 +-
>>  4 files changed, 56 insertions(+), 48 deletions(-)
>>
> ...
>> diff --git a/repair/da_util.c b/repair/da_util.c
>> index e5d5535..89d41cc 100644
>> --- a/repair/da_util.c
>> +++ b/repair/da_util.c
> ...
>> @@ -361,25 +366,27 @@ verify_final_da_path(
>>  	 */
>>  	if (cursor->level[this_level].hashval >=
>>  				be32_to_cpu(btree[entry].hashval)) {
>> -		do_warn(_("directory/attribute block hashvalue inconsistency, "
>> -			  "expected > %u / saw %u\n"),
>> +		do_warn(
>> +_("%s block hashvalue inconsistency, expected > %u / saw %u\n"),
>> +			FORKNAME(whichfork),
>>  			cursor->level[this_level].hashval,
>>  			be32_to_cpu(btree[entry].hashval));
>>  		bad++;
>>  	}
>>  	if (nodehdr.forw != 0) {
>> -		do_warn(_("bad directory/attribute forward block pointer, "
>> -			  "expected 0, saw %u\n"),
>> -			nodehdr.forw);
>> +		do_warn(
>> +_("bad %s forward block pointer, expected 0, saw %u\n"),
>> +			FORKNAME(whichfork), nodehdr.forw);
>>  		bad++;
>>  	}
>>  	if (bad) {
>> -		do_warn(_("bad directory block in inode %" PRIu64 "\n"), cursor->ino);
>> +		do_warn(_("bad %s block in inode %" PRIu64 "\n"),
>> +			FORKNAME(whichfork), cursor->ino);
>>  		return 1;
>>  	}
>>  	/*
>>  	 * keep track of greatest block # -- that gets
>> -	 * us the length of the directory
>> +	 * us the length of the directory/attribute 
> 
> Trailing whitespace above.

ok :)

Thanks,
-Eric

> Brian
> 
>>  	 */
>>  	if (cursor->level[this_level].bno > cursor->greatest_bno)
>>  		cursor->greatest_bno = cursor->level[this_level].bno;
>> @@ -389,9 +396,9 @@ verify_final_da_path(
>>  	 */
>>  	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
>>  #ifdef XR_DIR_TRACE
>> -		fprintf(stderr, "bad directory btree pointer, child bno should "
>> +		fprintf(stderr, "bad %s btree pointer, child bno should "
>>  				"be %d, block bno is %d, hashval is %u\n",
>> -			be16_to_cpu(btree[entry].before),
>> +			FORKNAME(whichfork), be16_to_cpu(btree[entry].before),
>>  			cursor->level[p_level].bno,
>>  			cursor->level[p_level].hashval);
>>  		fprintf(stderr, "verify_final_da_path returns 1 (bad) #1a\n");
>> @@ -403,17 +410,17 @@ verify_final_da_path(
>>  				be32_to_cpu(btree[entry].hashval)) {
>>  		if (!no_modify) {
>>  			do_warn(
>> -_("correcting bad hashval in non-leaf dir block\n"
>> +_("correcting bad hashval in non-leaf %s block\n"
>>   "\tin (level %d) in inode %" PRIu64 ".\n"),
>> -				this_level, cursor->ino);
>> +				FORKNAME(whichfork), this_level, cursor->ino);
>>  			btree[entry].hashval = cpu_to_be32(
>>  						cursor->level[p_level].hashval);
>>  			cursor->level[this_level].dirty++;
>>  		} else {
>>  			do_warn(
>> -_("would correct bad hashval in non-leaf dir block\n"
>> +_("would correct bad hashval in non-leaf %s block\n"
>>   "\tin (level %d) in inode %" PRIu64 ".\n"),
>> -				this_level, cursor->ino);
>> +				FORKNAME(whichfork), this_level, cursor->ino);
>>  		}
>>  	}
>>  
>> @@ -451,7 +458,7 @@ _("would correct bad hashval in non-leaf dir block\n"
>>  	 */
>>  	cursor->level[this_level].hashval = hashval;
>>  
>> -	return verify_final_da_path(mp, cursor, this_level);
>> +	return verify_final_da_path(mp, cursor, this_level, whichfork);
>>  }
>>  
>>  /*
>> @@ -564,8 +571,8 @@ verify_da_path(
>>  			&bmp, &lbmp);
>>  		if (nex == 0) {
>>  			do_warn(
>> -_("can't get map info for block %u of directory inode %" PRIu64 "\n"),
>> -				dabno, cursor->ino);
>> +_("can't get map info for %s block %u of inode %" PRIu64 "\n"),
>> +				FORKNAME(whichfork), dabno, cursor->ino);
>>  			return 1;
>>  		}
>>  
>> @@ -575,8 +582,8 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
>>  
>>  		if (!bp) {
>>  			do_warn(
>> -_("can't read block %u for directory inode %" PRIu64 "\n"),
>> -				dabno, cursor->ino);
>> +_("can't read %s block %u for inode %" PRIu64 "\n"),
>> +				FORKNAME(whichfork), dabno, cursor->ino);
>>  			return 1;
>>  		}
>>  
>> @@ -592,28 +599,28 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
>>  		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
>>  		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
>>  			do_warn(
>> -_("bad magic number %x in block %u for directory inode %" PRIu64 "\n"),
>> -				nodehdr.magic,
>> +_("bad magic number %x in %s block %u for inode %" PRIu64 "\n"),
>> +				nodehdr.magic, FORKNAME(whichfork),
>>  				dabno, cursor->ino);
>>  			bad++;
>>  		}
>>  		if (nodehdr.back != cursor->level[this_level].bno) {
>>  			do_warn(
>> -_("bad back pointer in block %u for directory inode %" PRIu64 "\n"),
>> -				dabno, cursor->ino);
>> +_("bad back pointer in %s block %u for inode %" PRIu64 "\n"),
>> +				FORKNAME(whichfork), dabno, cursor->ino);
>>  			bad++;
>>  		}
>>  		if (nodehdr.count > geo->node_ents) {
>>  			do_warn(
>> -_("entry count %d too large in block %u for directory inode %" PRIu64 "\n"),
>> -				nodehdr.count,
>> +_("entry count %d too large in %s block %u for inode %" PRIu64 "\n"),
>> +				nodehdr.count, FORKNAME(whichfork),
>>  				dabno, cursor->ino);
>>  			bad++;
>>  		}
>>  		if (nodehdr.level != this_level) {
>>  			do_warn(
>> -_("bad level %d in block %u for directory inode %" PRIu64 "\n"),
>> -				nodehdr.level,
>> +_("bad level %d in %s block %u for inode %" PRIu64 "\n"),
>> +				nodehdr.level, FORKNAME(whichfork),
>>  				dabno, cursor->ino);
>>  			bad++;
>>  		}
>> @@ -659,9 +666,9 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
>>  	 */
>>  	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
>>  #ifdef XR_DIR_TRACE
>> -		fprintf(stderr, "bad directory btree pointer, child bno "
>> +		fprintf(stderr, "bad %s btree pointer, child bno "
>>  			"should be %d, block bno is %d, hashval is %u\n",
>> -			be32_to_cpu(btree[entry].before),
>> +			FORKNAME(whichfork), be32_to_cpu(btree[entry].before),
>>  			cursor->level[p_level].bno,
>>  			cursor->level[p_level].hashval);
>>  		fprintf(stderr, "verify_da_path returns 1 (bad) #1a\n");
>> @@ -676,17 +683,17 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
>>  				be32_to_cpu(btree[entry].hashval)) {
>>  		if (!no_modify) {
>>  			do_warn(
>> -_("correcting bad hashval in interior dir block\n"
>> +_("correcting bad hashval in interior %s block\n"
>>    "\tin (level %d) in inode %" PRIu64 ".\n"),
>> -				this_level, cursor->ino);
>> +				FORKNAME(whichfork), this_level, cursor->ino);
>>  			btree[entry].hashval = cpu_to_be32(
>>  						cursor->level[p_level].hashval);
>>  			cursor->level[this_level].dirty++;
>>  		} else {
>>  			do_warn(
>> -_("would correct bad hashval in interior dir block\n"
>> +_("would correct bad hashval in interior %s block\n"
>>    "\tin (level %d) in inode %" PRIu64 ".\n"),
>> -				this_level, cursor->ino);
>> +				FORKNAME(whichfork), this_level, cursor->ino);
>>  		}
>>  	}
>>  	/*
>> diff --git a/repair/da_util.h b/repair/da_util.h
>> index 7971d63..442f9f1 100644
>> --- a/repair/da_util.h
>> +++ b/repair/da_util.h
>> @@ -78,5 +78,6 @@ int
>>  verify_final_da_path(
>>  	xfs_mount_t	*mp,
>>  	da_bt_cursor_t	*cursor,
>> -	const int	p_level);
>> +	const int	p_level,
>> +	int		whichfork);
>>  #endif	/* _XR_DA_UTIL_H */
>> diff --git a/repair/dir2.c b/repair/dir2.c
>> index 492b3e7..61912d1 100644
>> --- a/repair/dir2.c
>> +++ b/repair/dir2.c
>> @@ -1179,7 +1179,7 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
>>  		} else
>>  			libxfs_putbuf(bp);
>>  	} while (da_bno != 0);
>> -	if (verify_final_da_path(mp, da_cursor, 0)) {
>> +	if (verify_final_da_path(mp, da_cursor, 0, XFS_DATA_FORK)) {
>>  		/*
>>  		 * Verify the final path up (right-hand-side) if still ok.
>>  		 */
>> -- 
>> 1.7.1
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
