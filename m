Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 346037F89
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2015 14:11:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 242C3304053
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2015 12:11:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nGH9xkh6UVLzTPYH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Jun 2015 12:11:53 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 435918EFC5
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2015 19:11:52 +0000 (UTC)
Date: Tue, 30 Jun 2015 16:11:45 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_quota: Better describe quota verbose output
Message-ID: <20150630191145.GA6252@hades.maiolino.org>
References: <1435154949-14223-1-git-send-email-cmaiolino@redhat.com>
	<20150630183804.GA20427@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150630183804.GA20427@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

> > the available quota. Such behavior might make users confused, so, I believe it's
> > better to have the reasons for such behavior better documented.
> > 
> 
> Seems reasonable...
> 
> > +option outputs verbose information, displaying quota values even when there is
> > +no used space. Such behavior was chosen to be compliant with the 'quota' command
> > +and for historical reasons. The
> 
> ... though this sounds a bit unclear to me. Specifically, it sounds like
> it could be saying that the behavior of -v has some historical
> justification, when in fact, it is the absense of output in the
> non-verbose case that we're trying to document (assuming I understand
> the commit log correctly).
> 
> As an example, something like the following sounds more clear to me:
> 
> "The -v option outputs verbose information and includes quota limits
> with no consumption. By default, xfs_quota does not display limits with
> no consumption to maintain compatibility with the 'quota' command."
> 
> ... but I suspect it could still be worded better.
> 

Thank you for the comment Brian, I liked your idea, but, I'm also not the best
person to say if this is enough or not, I'll wait for some other comments here,
so I can send a V2 with our final decision.

Cheers

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
