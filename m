Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 041387F3F
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 21:45:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5754304043
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 19:45:00 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	iAbty5JHcZywknt0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 19:44:59 -0700 (PDT)
Received: by wibdy8 with SMTP id dy8so6095192wib.0
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 19:44:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550B858D.4030003@tlinx.org>
References: <1426720967-8215-1-git-send-email-david@fromorbit.com>
	<550B858D.4030003@tlinx.org>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 19 Mar 2015 22:44:18 -0400
Message-ID: <CAGpXXZL+6gdRM+fo1SMLVfCOErWQUiOGn0wH2iFhdkPY2-eqQA@mail.gmail.com>
Subject: Re: [PATCH] mkfs: default to CRC enabled filesystems
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 19, 2015 at 10:27 PM, Linda Walsh <xfs@tlinx.org> wrote:
> Dave Chinner wrote:
>>
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> It's time to change the mkfs defaults to enable CRCs for all new
>> filesystems.
>
> ---
>         "Sounds good", but what exactly is CRC'ed?
>
> I.e. all data? Or how much data/second would I expect
> to 'need' CRC'ing?

metadata only.

====
>From the man page:

       -m global_metadata_options
              These options specify metadata format options that either
              apply to the entire filesystem or aren't easily characterised
              by a specific functionality group. The valid
              global_metadata_options are:

                   crc=value
                          This is used to create a filesystem which
                          maintains and checks CRC information in all
                          metadata objects on disk. The value is either 0 to
                          disable the feature, or 1 to enable the use of
                          CRCs.

                          CRCs enable enhanced error detection due to
                          hardware issues, whilst the format changes also
                          improves crash recovery algorithms and the ability
                          of various tools to validate and repair metadata
                          corruptions when they are found.  The CRC
                          algorithm used is CRC32c, so the overhead is
                          dependent on CPU architecture as some CPUs have
                          hardware acceleration of this algorithm.
                          Typically the overhead of calculating and checking
                          the CRCs is not noticable in normal operation.

                          By default, mkfs.xfs will not enable metadata
                          CRCs.
====

The purpose of the patch is to drop "not" from the last sentence.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
