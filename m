Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70F9F7F51
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 02:24:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BE7BAC005
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 00:24:43 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtptls1-cha.cpub.univ-nantes.fr
	[193.52.103.113]) by cuda.sgi.com with ESMTP id
	hCMV4eVTJOv1uVWK for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 00:24:42 -0700 (PDT)
Message-ID: <516CFCB8.1060804@univ-nantes.fr>
Date: Tue, 16 Apr 2013 09:24:40 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: kernels 3.4 slower due to allocation workqueue
References: <516BCACE.1040900@univ-nantes.fr> <516C046C.8080908@sgi.com>
In-Reply-To: <516C046C.8080908@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Le 15/04/2013 15:45, Mark Tinguely a =E9crit :
>
> Here are the allocation worker changes.
>

Hello mark,  thanks for you answer

> The biggest performance commit should be aa292847, which limits the =

> callers to the worker.
>
> commit 3b876c8f2a361ceeed3fed894980c69066f903a0
> Author: Jeff Liu <jeff.liu@oracle.com>
> Date:   Thu Jun 7 15:44:32 2012 +0800
>
>     xfs: fix debug_object WARN at xfs_alloc_vextent()
>
> commit aa292847b9fc6e187547110de833a7d3131bbddf
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Thu Jul 12 07:40:43 2012 +1000
>
>     xfs: don't defer metadata allocation to the workqueue
>

Only These 2 commits are candidates, the others are post 3.5.
I'll try to patch a 3.4 with each patch.

>  commit 2455881c0b52f87be539c4c7deab1afff4d8a560
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Fri Oct 5 11:06:58 2012 +1000
>
>     xfs: introduce XFS_BMAPI_STACK_SWITCH
>
> commit e04426b9202bccd4cfcbc70b2fa2aeca1c86d8f5
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Fri Oct 5 11:06:59 2012 +1000
>
>     xfs: move allocation stack switch up to xfs_bmapi_allocate
>
> commit 9e96fe6df44425b69ed89f6ac20352cec1f127d7
> Author: Brian Foster <bfoster@redhat.com>
> Date:   Thu Jan 17 13:11:29 2013 -0500
>
>     xfs: pull up stack_switch check into xfs_bmapi_write
>
>
> The last 3 patches address an AGF buffer hang with the allocation worker.
>
> --Mark.

As 3.4 Kernels don't have thoses patches, is there a risk associated =

with  3.4 kernels ?

Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
