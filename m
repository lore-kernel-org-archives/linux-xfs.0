Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HHOCfh012034 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 12:24:12 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE11516C1222
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 10:32:01 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 4tPvTY0gllH9ZZwR for <xfs@oss.sgi.com>;
	Mon, 17 Oct 2011 10:32:01 -0700 (PDT)
Message-ID: <4E9C64B9.7070308@sandeen.net>
Date: Mon, 17 Oct 2011 12:24:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
References: <1318865412-4655-1-git-send-email-cmaiolino@redhat.com>
	<20111017140030.GA19136@infradead.org>
In-Reply-To: <20111017140030.GA19136@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On 10/17/11 9:00 AM, Christoph Hellwig wrote:
> This generally good, but you'll need to fix formatting a bit
> for both the mail body and the patch itself.
> 
> On Mon, Oct 17, 2011 at 01:30:12PM -0200, Carlos Maiolino wrote:
>> Fixes a possible memory corruption when the link
>> is larger than MAXPATHLEN and XFS_DEBUG is not
>> enabled.
>> This also uses S_IFLNK to check link not only
>> in DEBUG mode.
> 
> Please try to fill up ~ 75 characters for each line in the mail body,
> e.g.
> 
> Fix a possible memory corruption when a symlink target is larger than
> MAXPATHLEN and XFS_DEBUG is not enabled.  Also use S_IFLNK to check
> against disk corruption in di_mode for non-debug mode.
> 
> (I've also update the content a little bit).
> 
>> -	ASSERT(S_ISLNK(ip->i_d.di_mode));
>> -	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
>> +	if (!(S_ISLNK(ip->i_d.di_mode)) || !(ip->i_d.di_size <= MAXPATHLEN )){
>> +
>> +		xfs_emerg(mp, "inode (%lld), link too long or not a link",
>> +			 (unsigned long long)ip->i_ino);
>> +		ASSERT(0);
>> +		return XFS_ERROR(EFSCORRUPTED);
>> +	}
> 
> No need for the inner braces in both branches, but per kernel coding
> style there should be one before the opening brace.  Also no spaces
> before the closing round braces, please.  I also think it would be
> cleanrer to split this into two checks, as it's two possible
> corruptions, e.g.
> 
> 	if (!S_ISLNK(ip->i_d.di_mode)) {
> 		xfs_emerg(mp, "inode (%lld) not a link in %s\n",
> 			  (unsigned long long)ip->i_ino), __func__);
> 		ASSERT(0);
> 		return XFS_ERROR(EFSCORRUPTED);
> 	}


We could get here via xfs_readlink_by_handle, but that tests
S_ISLNK(dentry->d_inode->i_mode) before calling xfs_readlink.

I'm guessing that we wouldn't get here through normal paths
if the inode in question weren't a symlink, so is there any need
to re-test ip->i_d.di_mode here at runtime?

I'm not sure both ASSERTS necessarily need to be turned into runtime tests.
The 2nd does, clearly, so we don't overflow the buffer. Just not sure about
the first.

> 	if (ip->i_d.di_size > MAXPATHLEN) {
> 		xfs_emerg(mp, "inode (%lld) larger than MAXPATHLEN in %s\n",
> 			  (unsigned long long)ip->i_ino), __func__);
> 		ASSERT(0);
> 		return XFS_ERROR(EFSCORRUPTED);
> 	}

Since we assign "pathlen" a little later, it might be prettier to use that
variable at that point?  It's there, and it's descriptive.

Also, the current xfs_emerg() convention seems to be:

function: problem description

It might we worth following that, i.e.

xfs_emerg(mp, "%s: symlink target in inode %lld too long (%lld)", __func__, ip->i_ino, pathlen)
 
-Eric

> It might also be useful to print the length in the second case as that
> would help debugging potential corruptions. (e.g. single bit flips)
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
