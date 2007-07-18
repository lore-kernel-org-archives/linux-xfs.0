Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 13:57:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IKvKbm024174
	for <linux-xfs@oss.sgi.com>; Wed, 18 Jul 2007 13:57:22 -0700
Message-ID: <469E7D70.9030606@sandeen.net>
Date: Wed, 18 Jul 2007 15:52:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: tuning XFS for tiny files
References: <m23azlbpl1.fsf@tstotts.net>
In-Reply-To: <m23azlbpl1.fsf@tstotts.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: timotheus <timotheus@tstotts.net>
Cc: linux-xfs@oss.sgi.com

timotheus wrote:
> Hi. Is there a way to tune XFS filesystem parameters to better address
> the usage pattern of 10000s of tiny files in directories such as:
>     maildir directory
>     mh mail directory
>     ccache directory
> 
> My understanding is that XFS will always be much slower than reiserfs
> with respect to deleting 10000s files; but that XFS might be possible to
> tune toward more rapid read access of 10000s of tiny files.
> 
> Regards,
> -timotheus

Do you have a way to benchmark your load?

logv2 at mkfs time, and throwing in larger logbufs & logbsize as mount
options might help.

-Eric
