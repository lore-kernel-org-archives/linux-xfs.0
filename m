Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 290A07F66
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:54:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 089A6304067
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:54:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hMq32hJvezCGEQah for
	<xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:54:17 -0700 (PDT)
Date: Fri, 28 Jun 2013 14:54:06 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
Message-ID: <20130628185406.GB27157@redhat.com>
References: <20130613020827.GG29338@dastard> <20130613220903.GA20932@sgi.com>
	<20130614001306.GM29338@dastard> <20130614160940.GA32736@sgi.com>
	<51BB41AD.4050303@sandeen.net> <20130614190850.GB20932@sgi.com>
	<51BB6C7C.6050300@sandeen.net> <20130614194453.GC20932@sgi.com>
	<51BB74F0.7040406@sandeen.net> <20130614202223.GD20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130614202223.GD20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Jun 14, 2013 at 03:22:23PM -0500, Ben Myers wrote:

 > > > Are you guys arguing that the log replay bug should not be fixed?
 > > 
 > > Speaking for myself, I'm not arguing that, not at all.
 > > (not that I know how to fix it, either)
 > 
 > ...until log replay is fixed.  Hell.  I'll just pull it in as-is.
 > 
 > Reviewed-by: Ben Myers <bpm@sgi.com>

Is this on its way to Linus ? Given it's a regression over 3.9, it probably should be.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
