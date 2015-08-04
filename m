Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB17B7FA8
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 10:30:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8EF5C8F8037
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 08:30:55 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 6pMdKFWlEVt2VBOb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 08:30:53 -0700 (PDT)
Date: Tue, 4 Aug 2015 11:30:30 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1050814645.2742881.1438702230663.JavaMail.zimbra@redhat.com>
In-Reply-To: <55BFA2C5.20408@redhat.com>
References: <1156743222.24471614.1436281858017.JavaMail.zimbra@redhat.com>
	<1436346893-11831-1-git-send-email-jtulak@redhat.com>
	<1508777144.956841.1437482376774.JavaMail.zimbra@redhat.com>
	<20150726162530.GE29329@infradead.org>
	<1326157887.2004059.1438598404429.JavaMail.zimbra@redhat.com>
	<55BFA2C5.20408@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



----- Original Message -----
> From: "Eric Sandeen" <sandeen@redhat.com>
> To: "Jan Tulak" <jtulak@redhat.com>, "Christoph Hellwig" <hch@infradead.org>
> Cc: xfs@oss.sgi.com
> Sent: Monday, August 3, 2015 7:20:05 PM
> Subject: Re: [PATCH v3] xfsprogs: blkid is now mandatory
> 
> On 8/3/15 3:40 AM, Jan Tulak wrote:
> > 
> > 
> > ----- Original Message -----
> >> From: "Christoph Hellwig" <hch@infradead.org>
> >>
> >> On Tue, Jul 21, 2015 at 08:39:36AM -0400, Jan Tulak wrote:
> >>> I just found that while it is possible to get blkid on OS X, it is
> >>> in 1.0.0 version which doesn't have blkid_probe_get function.
> >>> I'm examining whether it is possible to get an updated version there,
> >>> but right now, this patch breaks OS X support. Unfortunately I didn't
> >>> noticed of this before, as the OS X port was terribly out of date.
> >>>
> >>> So this patch shouldn't be included until I find how to get around.
> >>
> >> I don't think this is a lbocker given that OSX support doesn't
> >> even work.
> >>
> >> To the contrary I'd really prefer to go in ASAP to avoid anyone
> >> relying on it longer than nessecary.
> > 
> > I tried to get newer blkid on OSX, but so far without a big success
> > (well, it looks like a kind of a small dependency hell that would
> > have to be ported, with bigger or smaller effort...). With regards
> > on the priorities, I think if we can make the OS X support in
> > "manual patching required" way, then?
> > 
> > So lets include this patch, and just note it OS X doc "you have to revert
> > commit XXX and re-apply any changes to the relevant code"?
> 
> IIRC block device signature detection isn't really required, it's just
> a nice-to-have; perhaps if blkid isn't present, that functionality can
> simply be disabled?

Signature detection (if I understand you correctly 'signature of existing 
FS') could be really disabled, I think. That would take care of 
check_overwrite(). However, blkid is also used in get_topology. That one
calls blkid_get_topology, which uses blkid's functions for finding out
sector and io sizes.

What I really can do is to say "on osx, you can mkfs only files," and cut
out the blkid parts. But it limits the usage on OS X even further.
Although, the removed code for non-blkid systems used platform_findsizes
as fallback. Are there some ugly, terrible monsters who would jump from
under the bed when doing that?

However, this patch affects only mkfs. It still should be possible to use
xfs_db and xfs_repair even on block devices. 

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
