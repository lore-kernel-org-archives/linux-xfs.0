Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E31577F3F
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 07:57:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B11728F8039
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 05:57:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lbC1AfmlTIgiAyZB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Oct 2014 05:57:21 -0700 (PDT)
Date: Tue, 21 Oct 2014 10:56:54 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs_vn_rename by xfs_vn_rename2
Message-ID: <20141021125654.GA26932@hades.localdomain>
References: <1413397042-32229-1-git-send-email-cmaiolino@redhat.com>
	<1413397042-32229-2-git-send-email-cmaiolino@redhat.com>
	<20141016210457.GA33732@bfoster.bfoster>
	<20141017093556.GA9146@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141017093556.GA9146@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Hi Brian, Chris.

Sorry my delay to reply, I was in a software conference this week, and barely
accessed my e-mails.

I can certainly re-do this patch to avoid the name change.

I used a new name to follow the VFS convention, although I also agree we
'should' get rig of several versions and keep just newer updates to the same
syscalls.

So, I'll re-do this patch and send a V2.

Cheers


On Fri, Oct 17, 2014 at 02:35:56AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 16, 2014 at 05:04:57PM -0400, Brian Foster wrote:
> > The function rename seems unnecessary..? Meh, not a big deal to me
> > either way. Otherwise, this one seems Ok.
> 
> Yeah, we might as well keep the old name.  As far as I'm concerned
> I'd love to get rid of the two different IOPS in the VFS, too.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
