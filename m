Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2129A7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 14:59:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 101928F8039
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 12:59:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tBVyQ4ILLG8L2E6h for
	<xfs@oss.sgi.com>; Fri, 25 Apr 2014 12:59:47 -0700 (PDT)
Message-ID: <535ABE9D.8070404@redhat.com>
Date: Fri, 25 Apr 2014 14:59:25 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: add heuristic to flush on rename
References: <535ABA9D.2060305@redhat.com>
	<20140425195528.GA16567@infradead.org>
In-Reply-To: <20140425195528.GA16567@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/25/14, 2:55 PM, Christoph Hellwig wrote:
>> +	/*
>> +	 * If we are renaming a just-written file over an existing
>> +	 * file, be pedantic and flush it out if it looks like somebody
>> +	 * is doing a tmpfile dance, and didn't fsync.  Best effort;
>> +	 * ignore errors.
>> +	 */
>> +	if (new_inode) {
>> +		xfs_inode_t *ip = XFS_I(odentry->d_inode);
>> +
>> +		if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
>> +			filemap_flush(new_inode->i_mapping);
>> +	}
> 
> IFF we want a heuristic it should be a proper filemap_write_and_wait.  a
> non-blocking start of I/O without waiting for it is snake oil.

Hi Christoph -

It's the same thing we do on truncated and written files, FWIW:

                truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
                if (truncated) {
                        xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
                        if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0) {
                                error = -filemap_flush(VFS_I(ip)->i_mapping);
                                if (error)
                                        return error;
                        }
                }

and that's served us pretty well in the past years.

I don't know if we're looking for rock-solid guarantees, or just do a little
to try to save the user from themselves... blocking would make this a lot more
heavyweight I suppose.  Just depends on what we are willing / trying to do.

thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
