Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6R7tC1S081156 for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 02:55:13 -0500
Subject: Re: [PATCH V4] reduce bmv_count in xfs_vn_fiemap
References: <4A5E2F01.7030107@sandeen.net>
	<bzybpnkhp62.fsf@fransum.emea.sgi.com> <4A5F3DBA.9040005@sandeen.net>
	<4A5F7B7B.6020903@sandeen.net> <4A6D1651.5010102@sandeen.net>
From: Olaf Weber <olaf@sgi.com>
Date: Mon, 27 Jul 2009 09:55:56 +0200
In-Reply-To: <4A6D1651.5010102@sandeen.net> (Eric Sandeen's message of "Sun,
	26 Jul 2009 21:52:01 -0500")
Message-ID: <bzybpn6y2yb.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen writes:

> commit 6321e3ed2acf3ee9643cdd403e1c88605d7944ba caused
> the full bmv_count's worth of getbmapx structures to get
> allocated; telling it to do MAXEXTNUM was a bit insane,
> resulting in ENOMEM every time.

> Chop it down to something reasonable, the number of slots
> in the caller's input buffer.  If this is too large the 
> caller may get ENOMEM but the reason should not be a
> mystery, and they can try again with something smaller.

> We add 1 to the value because in the normal getbmap
> world, bmv_count includes the header and xfs_getbmap does:

>         nex = bmv->bmv_count - 1;
>         if (nex <= 0)
>                 return XFS_ERROR(EINVAL);

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-By: Olaf Weber <olaf@sgi.com>


Thanks,

Olaf

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
