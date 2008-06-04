Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 06:54:17 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m54DsDid004839
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 06:54:14 -0700
Received: from villon.fh-worms.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC048177ADC0
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 06:55:06 -0700 (PDT)
Received: from villon.fh-worms.de (ns.fh-worms.de [143.93.160.9]) by cuda.sgi.com with ESMTP id TEGd3kn6aeXW3Cvo for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 06:55:06 -0700 (PDT)
Received: from sapserv.fh-worms.de (sapserv.fh-worms.de [143.93.160.2])
	by villon.fh-worms.de (8.14.3/8.14.2) with ESMTP id m54Dt4aX009820
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 15:55:04 +0200 (CEST)
Message-ID: <8efbf9761cbff87b03e5326866cd914d.squirrel@webmailer.fh-worms.de>
Date: Wed, 4 Jun 2008 15:55:04 +0200 (CEST)
Subject: vfs dmapi handle generation problem
From: Tim =?iso-8859-1?Q?J=F6dicke?= <tim.joedicke@fh-worms.de>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

hi,

i have a question about the dmapi support for xfs. in detail, it's about
the method "xfs_dm_inode_to_fh()". i tried to swap out this function to
vfs code and this is what it looks like now:

int
vfs_dm_inode_to_fh(struct inode *ip, dm_fid_t *dmfid, dm_fsid_t *dmfsid)
{
   dmfid->dm_fid_len = sizeof(dm_fid_t) - sizeof(dmfid->dm_fid_len);
   dmfid->dm_fid_pad = 0;
   memcpy(&dmfid->dm_fid_ino, &ip->i_ino, sizeof(dmfid->dm_fid_ino));
   dmfid->dm_fid_gen = ip->i_generation;

   *dmfsid = 11; // need generation system

   return 0;
}

don't be bothered by the fsid. ;) i use to have exactly one filesystem
registered und every time the fsid is used, it's 11. ;)

the problem is, that the generated handle is wrong. dm_handle_is_valid()
says, that the handle is valid, but i cannot set a disposition e.g. if i
get a handle via dm_path_to_fshandle() or dm_path_to_handle() (says the
handle is bad).

on the other hand, if i set a global disposition, receive the mount event
and get the fshandle from the message, the handle seems to be correct?

maybe you can give ma a hint? is something wrong with dm_inode_to_fh()?

thanks in advance,
tim
