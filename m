Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E1XRhr064793 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 20:33:38 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94A441B68A57
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:34:02 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id XWDEgp2WksusTaez for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:34:02 -0700 (PDT)
Message-ID: <4A84BF0A.2020003@sandeen.net>
Date: Thu, 13 Aug 2009 20:34:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: actually issue 0 size writes
References: <318271513.1935011250211412750.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <318271513.1935011250211412750.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> ----- "Eric Sandeen" <sandeen@sandeen.net> wrote:
> 
>> Felix Blyakher wrote:
>>> On Aug 13, 2009, at 5:15 PM, Eric Sandeen wrote:
>>>
>>>> While testing some stuff in generic_write_checks() in the
>>>> kernel I realized that you can't actually use xfs_io to send
>>>> a 0-byte write in.  This is actually a condition worth testing:
>>>>
>>>>       If  count  is zero and fd refers to a regular file,
>>>>       then write() may return a failure status if one  of
>>>>       the  errors  below  is  detected.  If no errors are
>>>>       detected, 0 will be returned  without  causing  any
>>>>       other  effect.
>>> As I understand the desire to be able to issue 0 size writes
>>> from xfs_io is to test the possibility of writing to a given fd.
>>> What kind of errors would you expect to test for?
>> In general EFBIG or ENOSPC.
>>
>> This sort of thing in generic_write_checks():
>>
>>         if (unlikely(*pos >= inode->i_sb->s_maxbytes)) {
>>                 if (*count || *pos > inode->i_sb->s_maxbytes) {
>>                      return -EFBIG;
>>                 }
>>                 /* zero-length writes at ->s_maxbytes are OK */
>>         }
>>
>> Although I'm a little confused about why "*pos == s_maxbytes" is ok;
>> I
>> thought s_maxbytes was a count/size whereas pos is an offset, so it
>> seems to me that pos == s_maxbytes is one past the max.  But anyway,
>> that's mostly unrelated to the patch in this thread.  :)

> pos == s_maxbytes is only okay if count == 0 also.  So even though we
> are writing at the limit we are not actually going to write anything.
> At s_maxbytes-1 we are allowed to write one byte and at s_maxbytes we
> are allowed to write nothing - literally.

I think my confusion over maxbytes is whether it's a size or an offset.

The comment says ... max size.

Also in the above function it does i_size_read on the block device -
again a size.

If it's a max offset you're right; if it's a max -size- then pos ==
s_maxbytes is already off the end, one past the limit.

-eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
