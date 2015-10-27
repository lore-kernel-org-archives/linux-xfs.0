Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 15D037F52
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 20:23:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5E3B304039
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 18:23:18 -0700 (PDT)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
	[209.85.215.51]) by cuda.sgi.com with ESMTP id 4WpcEuCwh40vftLj
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Oct 2015 18:23:16 -0700 (PDT)
Received: by lfaz124 with SMTP id z124so165585936lfa.1
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 18:23:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151026225520.GK8773@dastard>
References: <1445627828-14661-1-git-send-email-agruenba@redhat.com>
	<1445627828-14661-5-git-send-email-agruenba@redhat.com>
	<20151026225520.GK8773@dastard>
Date: Tue, 27 Oct 2015 02:23:15 +0100
Message-ID: <CAHc6FU6QfaLO5FpKHk4uoWFT7eyMC0baoRy12JRgnWOZ7zEDuA@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs_repair: Validate richacl attributes
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 26, 2015 at 11:55 PM, Dave Chinner <david@fromorbit.com> wrote:
> This also needs to check that the richacl feature bit is set
> apprpriately for the type of ACL that is found.

Ah, yes.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
