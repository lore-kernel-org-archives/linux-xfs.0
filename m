Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7474B7CB8
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 01:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 33CD0304039
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 23:33:27 -0700 (PDT)
Received: from mr002msb.fastweb.it (mr002msb.fastweb.it [85.18.95.86]) by
	cuda.sgi.com with ESMTP id WGUmDFpVfGIrrIo9 for
	<xfs@oss.sgi.com>; Sun, 29 May 2016 23:33:25 -0700 (PDT)
Subject: Re: LVM snapshot and log record CRC mismatch
MIME-Version: 1.0
Date: Mon, 30 May 2016 08:33:22 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20160526133422.32f65920@harpe.intellique.com>
References: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
	<20160524221205.GM21200@dastard> <57455645.5040608@assyoma.it>
	<20160526122315.4112f713@harpe.intellique.com>
	<5746DB30.5040006@assyoma.it>
	<20160526133422.32f65920@harpe.intellique.com>
Message-ID: <f5396f64997a30689dc4214dea6a4d8b@assyoma.it>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: g.danti@assyoma.it, xfs@oss.sgi.com

Il 26-05-2016 13:34 Emmanuel Florac ha scritto:
> 
> Yes, I thought that too, however it doesn't seem to be working in your
> case, and freezing twice can't do any harm anyway :)

Hi all,
after upgrading to CentOS 7.2, kernel version 
3.10.0-327.18.2.el7.x86_64, the problem was solved: mounting a snapshot 
shows no more CRC error (ie: the filesystem is quiesced before taking 
the snapshot).

I am not sure of what component upgrade solved the problem, if kernel or 
lvm tools. I are more inclined to the latter, anyway.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
