Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 726227F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 11:17:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52BD730406B
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:17:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EOGSXvB41UlbeSA4 for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:17:31 -0700 (PDT)
Date: Tue, 15 Apr 2014 18:09:34 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
In-Reply-To: <20140415153643.GB4456@thunk.org>
Message-ID: <alpine.LFD.2.00.1404151808440.2146@localhost.localdomain>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
	<20140412152117.GB18047@infradead.org>
	<alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
	<20140415153643.GB4456@thunk.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1907578942-1397578177=:2146"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1907578942-1397578177=:2146
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 15 Apr 2014, Theodore Ts'o wrote:

> Date: Tue, 15 Apr 2014 11:36:43 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
>     ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
> 
> On Tue, Apr 15, 2014 at 03:10:38PM +0200, Lukáš Czerner wrote:
> > 
> > I'll update the description and the subject.
> 
> Lukáš, FYI, I'm waiting for your update(s) to these patches in
> response to Christoph's comments.
> 
> I'd like to push a set of bugfixes to Linus, hopefully this week so
> they can make -rc2.
> 
> Cheers,
> 
> 					- Ted
> 

Ok, I'll run some tests and resend it right away without the patch
#4.

Thanks!
-Lukas
--8323328-1907578942-1397578177=:2146
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1907578942-1397578177=:2146--
