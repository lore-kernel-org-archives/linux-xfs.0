Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4838C7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 11:19:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C2B28AC002
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 09:19:45 -0700 (PDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id 0z6KbxsIPcwr15oG
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 09:19:40 -0700 (PDT)
Received: by mail-wm0-f51.google.com with SMTP id z87so115041246wmh.0
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 09:19:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160531125157.GB17018@infradead.org>
References: <1437913255-7524-4-git-send-email-tytso@mit.edu>
	<1454361909-36538-1-git-send-email-gwendal@chromium.org>
	<20160202180828.GA13880@infradead.org>
	<CAMHSBOUQ5eUL+Y+voDCwC9U7gmTsUZu2Oympn+c0=DxaU4egjA@mail.gmail.com>
	<20160531125157.GB17018@infradead.org>
From: Gwendal Grignou <gwendal@chromium.org>
Date: Tue, 31 May 2016 09:19:19 -0700
Message-ID: <CAMHSBOU5+XsM503_3khtVBWa+Ymz9BrezGzpxpJEr3axCMuR1Q@mail.gmail.com>
Subject: Re: xfsprogs: Add BUILD_CFLAGS for cross compilation
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
Cc: vapier@gentoo.org, Gwendal Grignou <gwendal@chromium.org>, Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, xfs@oss.sgi.com

[+Mike]
Sure. Mike suggested improvements (ability to specify the host
compiler), and found I did not properly regenerate ./configure. I will
resubmit a better patch.
Gwendal.

On Tue, May 31, 2016 at 5:51 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 27, 2016 at 09:34:50AM -0700, Gwendal Grignou wrote:
>> Looking at xfsprogs-4.5.0, that patch has not been applied. Did it not work?
>> It still applies cleanly on 4.5.
>
> It probably just got missed by Dave between all the patches on the list.
> Can you just resend it with my Reviewed-by tag added?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
