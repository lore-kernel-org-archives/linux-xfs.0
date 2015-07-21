Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E5CE7F82
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 07:40:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 12A188F8049
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 05:40:01 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id 6H8cr3qUHipPOhi8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 05:39:59 -0700 (PDT)
Date: Tue, 21 Jul 2015 08:39:36 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1508777144.956841.1437482376774.JavaMail.zimbra@redhat.com>
In-Reply-To: <1436346893-11831-1-git-send-email-jtulak@redhat.com>
References: <1156743222.24471614.1436281858017.JavaMail.zimbra@redhat.com>
	<1436346893-11831-1-git-send-email-jtulak@redhat.com>
Subject: Re: [PATCH v3] xfsprogs: blkid is now mandatory
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, sandeen@redhat.com



----- Original Message -----
> From: "Jan Tulak" <jtulak@redhat.com>
> Subject: [PATCH v3] xfsprogs: blkid is now mandatory
> 
> Because blkid is here for a long time, I hereby propose a patch for
> removing support for NOT having blkid. The current support through
> set of #ifdef is prone to errors like
> making a patch just in one of the branches, and according to a
> recent talk between Christoph and Eric, it is not necessary to keep
> it supported.
> 
> Remove code for checking ENABLE_BLKID, and the code when
> ENABLE_BLKID is not defined.  The only use of libdisk was in the
> removed code, so remove libdisk too.  It makes blkid required for
> compilation.
> 

I just found that while it is possible to get blkid on OS X, it is
in 1.0.0 version which doesn't have blkid_probe_get function.
I'm examining whether it is possible to get an updated version there,
but right now, this patch breaks OS X support. Unfortunately I didn't
noticed of this before, as the OS X port was terribly out of date.

So this patch shouldn't be included until I find how to get around.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
