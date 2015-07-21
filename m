Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B07417F75
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 04:19:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 923548F804C
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 02:18:59 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id k3VIveTS0kYlXrB6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 02:18:57 -0700 (PDT)
Date: Tue, 21 Jul 2015 05:18:54 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <2080505999.894659.1437470334861.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150721063738.GA7943@dastard>
References: <2035333009.511763.1437398166766.JavaMail.zimbra@redhat.com>
	<1213913978.543970.1437400666553.JavaMail.zimbra@redhat.com>
	<20150721063738.GA7943@dastard>
Subject: Re: xfsprogs: useless code blocks
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
To: Dave Chinner <david@fromorbit.com>, nathans@redhat.com
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Nathan,
I'm sending this also to you, as it is about one old your patch
you posted to xfsprogs. Can you look at the two lines, if you
recall their purpose? :-)

----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "Jan Tulak" <jtulak@redhat.com>
> Cc: "xfs-oss" <xfs@oss.sgi.com>
> Sent: Tuesday, July 21, 2015 8:37:38 AM
> Subject: Re: xfsprogs: useless code blocks
> 
> On Mon, Jul 20, 2015 at 09:57:46AM -0400, Jan Tulak wrote:
> > Hi all,
> > 
> > I found these useless bits of code in xfsprogs:
> > 
> > repair/incore_ino.c:575-576:
> > if (ino_rec->ino_startnum == 0)
> >   ino_rec = ino_rec;
> > 
> > This one is pretty clear. It is there since 2001 (commit 2bd0ea187
> > by nathans@sgi.com, who didn't wrote here since 2006, so I find
> 
> nathans@redhat.com will get you that same person ;)
> 
> > CC-ing him useless). It looks like a forgotten code which doesn't
> > do anything, but I ask in case it is a hidden bug.
> 
> Who knows? It came from the Irix code base by the look of it, so
> maybe it was just working around a compiler bug?
> 

All right, I'm adding him, we will see.

> > And:
> > 
> > db/check.c:3035, 3037: Always true expression, as be32_to_cpu()
> > translates to __u32 type and unsigned can't be less than zero.
> > 
> > be32_to_cpu(free->hdr.nvalid) < 0 ||
> 
> The old endian conversion stuff in userspace needed that. When we
> converted it to the same as the kernel macros, we didn't change any
> of the logic. gcc isn't warning about this on x86-64, so in general
> signed/unsigned stuff goes unnoticed.
> 

I found it during my OS X porting - clang complains. So I will remove it,
although I will wait at first if Nathan has anything to say about the
ino_rec self-assignment.

Cheers,
Jan
-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
