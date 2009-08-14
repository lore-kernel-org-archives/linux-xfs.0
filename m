Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E0F8fa059805 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 19:15:18 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8828D1B68FEA
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:15:45 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id BCI8McpsFMTFGTgM for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:15:45 -0700 (PDT)
Message-ID: <4A84ACB1.7070602@sandeen.net>
Date: Thu, 13 Aug 2009 19:15:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: actually issue 0 size writes
References: <4A849096.1010600@sandeen.net>
	<1CDE853D-47DB-4E76-8D8F-DA1B77CC1F54@sgi.com>
In-Reply-To: <1CDE853D-47DB-4E76-8D8F-DA1B77CC1F54@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

Felix Blyakher wrote:
> On Aug 13, 2009, at 5:15 PM, Eric Sandeen wrote:
> 
>> While testing some stuff in generic_write_checks() in the
>> kernel I realized that you can't actually use xfs_io to send
>> a 0-byte write in.  This is actually a condition worth testing:
>>
>>       If  count  is zero and fd refers to a regular file,
>>       then write() may return a failure status if one  of
>>       the  errors  below  is  detected.  If no errors are
>>       detected, 0 will be returned  without  causing  any
>>       other  effect.
> 
> As I understand the desire to be able to issue 0 size writes
> from xfs_io is to test the possibility of writing to a given fd.
> What kind of errors would you expect to test for?

In general EFBIG or ENOSPC.

This sort of thing in generic_write_checks():

        if (unlikely(*pos >= inode->i_sb->s_maxbytes)) {
                if (*count || *pos > inode->i_sb->s_maxbytes) {
                     return -EFBIG;
                }
                /* zero-length writes at ->s_maxbytes are OK */
        }

Although I'm a little confused about why "*pos == s_maxbytes" is ok; I
thought s_maxbytes was a count/size whereas pos is an offset, so it
seems to me that pos == s_maxbytes is one past the max.  But anyway,
that's mostly unrelated to the patch in this thread.  :)

-Eric

> Otherwise looks good.
> 
> Felix


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
