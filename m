Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA08C3524F
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04B7421927
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltjZNNWX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgBEGzS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 01:55:18 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40724 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgBEGzS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 01:55:18 -0500
Received: by mail-il1-f193.google.com with SMTP id i7so961451ilr.7;
        Tue, 04 Feb 2020 22:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4AA1F5TWGVsxveJtsuc5HZZRZPRGGdeZZ+73WmC7wtE=;
        b=ltjZNNWX1hRxH/ymxgCm+t8L3LTwkVp3PjnbB+ZcB2uZMsb50k2hw8E2QNbBpmfmiI
         I0s5ksV2pIOrKcw+vhm1MxrAY2ix+GmbIRUv8JTs7rLeJchhOnAaNIPAFEHeUPoIKiUF
         12PE879HODkvAlEAmQdvwZXjkjxritUynE2OxdBiO4uohp6BAD4TLJ2r53qRPV72CFaI
         7SltJce83fpXPdB6I61eyoAFf2R891VVVAfMlXFOb+a4pJLr+tQuOjXA5C5TQwBCsomP
         cchRWBtV6rmEepwWXOajTUpp7plIDqFNp5djhkn3Bggnwka9g9tu6My0Q47rGZslynKi
         3suA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4AA1F5TWGVsxveJtsuc5HZZRZPRGGdeZZ+73WmC7wtE=;
        b=SPLLp9Mh5iHeLJT2Ur6uBfn5O1ReIQxceWH0uNq03ozivxVy4wVy3/BkWjpzNTOGWG
         eJXqKOdqnV+QI8sAd2cX3GbfyihTadvP0Z4PrraCdIiYJ49zwW70M6crvPyR+grxlJJj
         a03d1QYQfk/EAMpkL/DW2BDEOBrF27DKKSAdaB5zdGC8iq+hCDNnzA/ZPbF+1eyDHEaa
         g1grqZiNqqfMQDJnb7GsB3rINXWjnOfSHBRV3eY45oO43H/eH24BJLouL4hM5PlgM1xq
         hvcp0bGFXVbDOBTnAKhK0R9nf9vXVSn2Xz9/XacT7WFtf6ta5wi6pnSlIloMJAaAZiN2
         LH0g==
X-Gm-Message-State: APjAAAU6IjTQGjmPmQgTTuyl0U2UwChJnDmpDdy5VKE46elbaEppI2eD
        I11Bfk0LM0F4szs256feZxdfqt8NTAK8831776k=
X-Google-Smtp-Source: APXvYqzdljwWOahm5VBi7+srRJXHWl5qbAYsb0csgxnSXsDOW4PKtcMcAt8gY/gmxZkWqvvxByOPZLEsEMIlRXI2n0k=
X-Received: by 2002:a92:8656:: with SMTP id g83mr25504865ild.9.1580885717689;
 Tue, 04 Feb 2020 22:55:17 -0800 (PST)
MIME-Version: 1.0
References: <158086090225.1989378.6869317139530865842.stgit@magnolia> <158086092087.1989378.18220785148122680849.stgit@magnolia>
In-Reply-To: <158086092087.1989378.18220785148122680849.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 5 Feb 2020 08:55:06 +0200
Message-ID: <CAOQ4uxi7eDjzjxOU=2_w=putAErKTCTNUqJA-JKef3X9LLZOvQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] generic/402: skip test if xfs_io can't parse the date value
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 5, 2020 at 2:02 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> If xfs_io's utimes command cannot interpret the arguments that are given
> to it, it will print out "Bad value for [am]time".  Detect when this
> happens and drop the file out of the test entirely.
>
> This is particularly noticeable on 32-bit platforms and the largest
> timestamp seconds supported by the filesystem is INT_MAX.  In this case,
> the maximum value we can cram into tv_sec is INT_MAX, and there is no
> way to actually test setting a timestamp of INT_MAX + 1 to test the
> clamping.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/402 |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
>
> diff --git a/tests/generic/402 b/tests/generic/402
> index 2a34d127..32988866 100755
> --- a/tests/generic/402
> +++ b/tests/generic/402
> @@ -63,10 +63,19 @@ run_test_individual()
>         # check if the time needs update
>         if [ $update_time -eq 1 ]; then
>                 echo "Updating file: $file to timestamp $timestamp"  >> $seqres.full
> -               $XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file
> +               $XFS_IO_PROG -f -c "utimes $timestamp 0 $timestamp 0" $file >> $tmp.utimes 2>&1

Maybe use > instead of >> to be safe.

Also I would feel more comfortable if we special case the 0 timestamp
against being skipped, to be safe that we don't have a silent regression
in xfs_io or something causing all files to be skipped.

Otherwise:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> +               cat $tmp.utimes >> $seqres.full
> +               if grep -q "Bad value" "$tmp.utimes"; then
> +                       rm -f $file $tmp.utimes
> +                       return
> +               fi
> +               cat $tmp.utimes
> +               rm $tmp.utimes
>                 if [ $? -ne 0 ]; then
>                         echo "Failed to update times on $file" | tee -a $seqres.full
>                 fi
> +       else
> +               test -f $file || return
>         fi
>
>         tsclamp=$((timestamp<tsmin?tsmin:timestamp>tsmax?tsmax:timestamp))
>
