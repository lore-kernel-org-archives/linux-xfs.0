Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67GKDPa182108 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 11:20:15 -0500
Received: from mail.lncsa.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BFE153C3A
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 09:20:11 -0700 (PDT)
Received: from mail.lncsa.com (mail.lncsa.com [213.215.28.11]) by cuda.sgi.com
	with ESMTP id wQW3uA7ZQkOFWQth for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 09:20:11 -0700 (PDT)
Message-ID: <4E15DCB8.202@lncsa.com>
Date: Thu, 07 Jul 2011 18:20:08 +0200
From: Laurent CARON <lcaron@lncsa.com>
MIME-Version: 1.0
Subject: Re: Number of ACLs
References: <4E15AA1A.3090802@lncsa.com>
	<20110707152616.0e03b866@harpe.intellique.com>
In-Reply-To: <20110707152616.0e03b866@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 07/07/2011 15:26, Emmanuel Florac wrote:
> Le Thu, 07 Jul 2011 14:44:10 +0200
> Laurent CARON<lcaron@lncsa.com>  =E9crivait:
>
>> I'd like to know if it is possible in a simple&  safe way to increase
>> the number of supported ACLs on an already existing FS.
>
> I just realised I missed that part : there is absolutely no way to
> change an existing filesystem after the fact.
>
> My previous answer was about the fact that by installing a modified
> kernel module, there is a slight possibility that you can create a
> NEW filesystem with more ACLs (and beware, this is untested,
> unsupported, uncharted territory, "there be dragons" and al). Given that
> the modified xfs module actually works, given that the mkfs.xfs and
> other tools behave as expected (unlikely), and that the whole setup
> won't fall down in flames the first time you actually create 26 ACLs on
> a file, etc.
>

Thanks.

I'll cope with this limit for now and eventually will move to some other =

FS in the future if I still need to use more than 25 ACLs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
