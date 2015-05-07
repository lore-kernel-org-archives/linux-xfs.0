Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D48007F37
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 08:54:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61703AC003
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 06:54:09 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 3dwdJzFnbLm5XSzW for
	<xfs@oss.sgi.com>; Thu, 07 May 2015 06:54:07 -0700 (PDT)
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Valid Benchmark Value & Methods
Date: Thu, 07 May 2015 15:54:06 +0200
Message-ID: <1889263.HCPQcpsWke@merkaba>
In-Reply-To: <554B5782.4040303@xtremenitro.org>
References: <554B4B59.6000706@xtremenitro.org> <2204700.QypQcg3ER3@merkaba>
	<554B5782.4040303@xtremenitro.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dewangga <dewanggaba@xtremenitro.org>
Cc: xfs@oss.sgi.com

Am Donnerstag, 7. Mai 2015, 19:16:02 schrieb Dewangga:
> Hello Martin,
> Thanks for your reply, yes I've read that link, but another question,
> is noatime,nodiratime,etc still valid for performance tuning guidance?
> Even the default mount options only "rw,inode64,seclabel,attr2".
> =

> Is it still increase the performance if the additional mount options
> added?

noatime implies nodiratime as far as I know.

And yes, it can help for databases for example. I think official =

recommendation for MySQL and PostgreSQL is to use noatime. There is a post =

by Theodore T=B4so somewhere about make clean workload on Ext4 with noatime=
, =

relatime and strictatime handling and only noatime considerably reduced the =

amount of writes.

noatime is a generic tuning option which can help with other filesystems as =

well.

-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
