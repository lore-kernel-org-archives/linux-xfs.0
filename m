Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FC587F4E
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 05:40:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E4E08F8126
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 03:40:29 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id qi0QTQvqGat0Pkp6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 03:40:28 -0700 (PDT)
Date: Mon, 3 Aug 2015 06:40:04 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1326157887.2004059.1438598404429.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150726162530.GE29329@infradead.org>
References: <1156743222.24471614.1436281858017.JavaMail.zimbra@redhat.com>
	<1436346893-11831-1-git-send-email-jtulak@redhat.com>
	<1508777144.956841.1437482376774.JavaMail.zimbra@redhat.com>
	<20150726162530.GE29329@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: sandeen@redhat.com, xfs@oss.sgi.com



----- Original Message -----
> From: "Christoph Hellwig" <hch@infradead.org>
> 
> On Tue, Jul 21, 2015 at 08:39:36AM -0400, Jan Tulak wrote:
> > I just found that while it is possible to get blkid on OS X, it is
> > in 1.0.0 version which doesn't have blkid_probe_get function.
> > I'm examining whether it is possible to get an updated version there,
> > but right now, this patch breaks OS X support. Unfortunately I didn't
> > noticed of this before, as the OS X port was terribly out of date.
> > 
> > So this patch shouldn't be included until I find how to get around.
> 
> I don't think this is a lbocker given that OSX support doesn't
> even work.
> 
> To the contrary I'd really prefer to go in ASAP to avoid anyone
> relying on it longer than nessecary.

I tried to get newer blkid on OSX, but so far without a big success 
(well, it looks like a kind of a small dependency hell that would 
have to be ported, with bigger or smaller effort...). With regards 
on the priorities, I think if we can make the OS X support in 
"manual patching required" way, then? 

So lets include this patch, and just note it OS X doc "you have to revert
commit XXX and re-apply any changes to the relevant code"?

Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
