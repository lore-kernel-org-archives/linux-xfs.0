Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 689A07F3F
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 22:13:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12BE7AC003
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 20:12:57 -0700 (PDT)
Received: from mail-qa0-f43.google.com (mail-qa0-f43.google.com
	[209.85.216.43]) by cuda.sgi.com with ESMTP id MyHZKv3vMUwoqa4X
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 28 Jul 2013 20:12:56 -0700 (PDT)
Received: by mail-qa0-f43.google.com with SMTP id cl20so1413786qab.2
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 20:12:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130729024546.GD13468@dastard>
References: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
	<20130726025009.GE21982@dastard>
	<CAEH94Lh-UCCEs7hQi_t5v+X+ER1DH9dCtjr6e9GVNX5KJ-f1hQ@mail.gmail.com>
	<20130726113521.GM13468@dastard>
	<CAEH94Ljpih875VOEdCY9Z9CdMF_1DesW7dsz_k7Zm=xt165w5A@mail.gmail.com>
	<20130729024546.GD13468@dastard>
Date: Mon, 29 Jul 2013 11:12:55 +0800
Message-ID: <CAEH94LgBN70u8+jnd4y3jsxf53U07CG=HWfB9VOvE-VoZG9SKw@mail.gmail.com>
Subject: Re: [PATCH] xfs: introduce object readahead to log recovery
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Mon, Jul 29, 2013 at 10:45 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jul 29, 2013 at 09:38:11AM +0800, Zhi Yong Wu wrote:
>> By the way, how do you try the workload which has nothing but dirty
>> dquote objects?
>
> Create quota limits for non-existent users. That will allocate the
> dquots and dirty them.
>
> Or if you already have a few hundred thousand dquots, just change
> the limits on them all to get them logged and dirty...
OK, thanks.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
