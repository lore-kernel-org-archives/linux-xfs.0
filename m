Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6GEJAfc020477 for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 09:19:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC099139C750
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 07:19:45 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id SPYrk0jjKXmFjNwO for
	<xfs@oss.sgi.com>; Thu, 16 Jul 2009 07:19:45 -0700 (PDT)
Message-ID: <4A5F36FE.4050200@sandeen.net>
Date: Thu, 16 Jul 2009 09:19:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] reduce bmv_count in xfs_vn_fiemap
References: <4A5E2F01.7030107@sandeen.net>
	<bzybpnkhp62.fsf@fransum.emea.sgi.com>
In-Reply-To: <bzybpnkhp62.fsf@fransum.emea.sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

Olaf Weber wrote:
> Eric Sandeen writes:
> 
>> commit 6321e3ed2acf3ee9643cdd403e1c88605d7944ba caused
>> the full bmv_count's worth of getbmapx structures to get
>> allocated; telling it to do MAXEXTNUM was a bit insane,
>> resulting in ENOMEM.
> 
>> Chop it down to something reasonable, the caller can
>> loop over this if the file has > 64 extents.
> 
> It does seem to me that this will result in an unusal case for the
> caller, in that it will get fewer extents than fit in the provided
> buffer, yet should loop.  Do current callers know that they can hit
> this case, detect it, and loop accordingly?  Or is this just pushing
> the problem/regression to userspace?

Well, userspace just keeps calling until it gets FIEMAP_LAST in the
flags.  But yeah, I forgot that we were given the nr of user extents,
I'll send a better V2.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
