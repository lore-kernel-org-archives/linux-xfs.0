Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Sep 2006 01:02:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8P82AaG011099
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 01:02:12 -0700
Message-ID: <45178D19.5000803@sgi.com>
Date: Mon, 25 Sep 2006 18:02:33 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH -mm] rescue large xfs preferred iosize from the inode
 diet patch
References: <45131334.6050803@sandeen.net>	<45134472.7080002@sgi.com> <20060922161040.609286fa.akpm@osdl.org>
In-Reply-To: <20060922161040.609286fa.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Andrew Morton wrote:
> On Fri, 22 Sep 2006 12:03:30 +1000

>> Looked at your patch and then at our xfs code in the tree and
>> the existing code is different than what yours is based on.
>> I then noticed in the logs Nathan has actually made changes for this:
>>
>> ----------------------------
>> revision 1.254
>> date: 2006/07/17 10:46:05;  author: nathans;  state: Exp;  lines: +20 -5
>> modid: xfs-linux-melb:xfs-kern:26565a
>> Update XFS for i_blksize removal from generic inode structure
>> ----------------------------
>> I even reviewed the change (and I don't remember it - getting old).
>>
>> I looked at the mods scheduled for 2.6.19 and this is one of them.
>>
>> So the fix for this is coming soon (and the fix is different from the
>> one above).
>>
> 
> eh?  Eric's patch is based on -mm, which includes the XFS git tree.  If I
> go and merge the inode-diet patches from -mm, XFS gets broken until you
> guys merge the above mystery patch.  (I prefer to merge the -mm patches
> after all the git trees have gone, but sometimes maintainers dawdle and I
> get bored of waiting).
> 
> Is git://oss.sgi.com:8090/nathans/xfs-2.6 obsolete, or are you hiding stuff
> from me?  ;)
> 
:)
We're still getting our act together since Nathan is no longer here.
Going forward the new git tree is at:
     git://oss.sgi.com:8090/xfs/xfs-2.6

This has some more recent changes than the "nathans" one but
is far from up to date with the internal sgi tree and the external
cvs tree (as you noticed with the nathans one:).

I will get the "xfs" one updated in the next day or so.

(Aside: for some strange reason, the "nathans" one has 3 extra
  mods (commits) and as expected (to me:) the "xfs" one has 10 extra
  mods (commits) and there is about 46 mods (including missing 3)
  pending for the "xfs" tree.
  If we end up moving from our internal SCM to git at some point,
  this could make the updates less of a hassle:).


--Tim
