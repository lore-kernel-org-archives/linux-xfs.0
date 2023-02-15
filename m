Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B829C636D7
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 18:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBOSxh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 13:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBOSxg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2023 13:53:36 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23EA3BD85;
        Wed, 15 Feb 2023 10:53:35 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gd1so8331359pjb.1;
        Wed, 15 Feb 2023 10:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FuyBqtDGaHZHREB9GLngqLrWDqUte58Ky64gFFEp2iM=;
        b=UPde6kLLGTSTuId/BSI4+wHwhi5jpC6HIGQFd3N+en1Db6KzDV8yQbrAscZtQOTzg3
         ofGkV8Cr/F6OGhzWvjckzaGbuvEhThl0xhOgKbSKmlomlRbqsBpOCaSy1mr0zeYtgWsH
         ZwNYo8fN2jRHyX4cZbrX7997IdEPRV8QfmuWOuiwCQ9MP5SM+5/D9Y/1CM2QKbkVeIRM
         8Dn5D4pWMxIMzmGvR4UM2DQCwxFdW9t5iDdB/SB8lP80OzAyQaperg9IeRtLNKqTOkYN
         0JlqQR7aygSIHOevqxew6sS6yZPWkU+sf1j3YRF8eFGTdVoi9vPsHzYEUEbkDdEDbEDg
         x0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuyBqtDGaHZHREB9GLngqLrWDqUte58Ky64gFFEp2iM=;
        b=UK0vQfzusX4Fd6QdsoztXs/ZGoHuL0lUaJC70oXnO+/z2JRpfO+GTbUcJC4ciHxLBv
         JlsTha4/sPxRT2u9oDrwEx+12/wE3MzAhHEVepjEUaOyLzixde5gEHLvBKKeOS73zJ5X
         Y45dPE0n78AAe28FPqFX73AhudOI3TFtQXCndEME8BRKjW4pKN3f8kUcWc0G3+7fDaaq
         OrjaTf8e2NOLfGyLeq6AE28qRPR2NWFt7dIuMGrFP1Z3iVV70wxhV4B9I3Q7FGZpjCf+
         kurRq4YNnc/BkSRqYWNfX/g0XC+Xo6rP+KWrQkalzHWTfy/vmgRMcYjMOrPCKIj32icw
         xApw==
X-Gm-Message-State: AO0yUKXamFkZYVi63VXfOGFZkNfgQHC9T7ShOH6caanK8xE28oEYYNTU
        wPmv5j9OnzVYybdCNGrspuI=
X-Google-Smtp-Source: AK7set99br2gqTMa8L3CMinzGgfJmrgd3SQDpO5SFzHstLo4eNO4DPnDPlAD7+sxPwctirAUKP3j6Q==
X-Received: by 2002:a05:6a20:12c2:b0:be:d4be:50a2 with SMTP id v2-20020a056a2012c200b000bed4be50a2mr3695916pzg.32.1676487215160;
        Wed, 15 Feb 2023 10:53:35 -0800 (PST)
Received: from google.com ([2601:647:4701:18d0:84c5:281b:cb7d:4ee6])
        by smtp.gmail.com with ESMTPSA id u9-20020aa78389000000b00593b06e0493sm12021795pfm.81.2023.02.15.10.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:53:34 -0800 (PST)
Date:   Wed, 15 Feb 2023 10:53:32 -0800
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, quwenruo.btrfs@gmx.com,
        tytso@mit.edu
Subject: Re: [PATCH 01/14] check: generate section reports between tests
Message-ID: <Y+0qLPSsWZnG3XvJ@google.com>
References: <167642553879.2118945.15448815976865210889.stgit@magnolia>
 <167642554451.2118945.4503850138465303711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167642554451.2118945.4503850138465303711.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 14, 2023 at 05:45:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Generate the section report between tests so that the summary report
> always reflects the outcome of the most recent test.  Two usecases are
> envisioned here -- if a cluster-based test runner anticipates that the
> testrun could crash the VM, they can set REPORT_DIR to (say) an NFS
> mount to preserve the intermediate results.  If the VM does indeed
> crash, the scheduler can examine the state of the crashed VM and move
> the tests to another VM.  The second usecase is a reporting agent that
> runs in the VM to upload live results to a test dashboard.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  check |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> 
> diff --git a/check b/check
> index 0bf5b22e06..14b398fd73 100755
> --- a/check
> +++ b/check
> @@ -844,6 +844,15 @@ function run_section()
>  		fi
>  		seqres="$REPORT_DIR/$seqnum"
>  
> +		# Generate the entire section report with whatever test results
> +		# we have so far.  Leave the $sect_time parameter empty so that
> +		# it's a little more obvious that this test run is incomplete.
> +		if $do_report; then
> +			_make_section_report "$section" "${#try[*]}" \
> +					     "${#bad[*]}" "${#notrun[*]}" \
> +					     "" &> /dev/null
> +		fi
> +
>  		mkdir -p $RESULT_DIR
>  		rm -f ${RESULT_DIR}/require_scratch*
>  		rm -f ${RESULT_DIR}/require_test*
>

This works for me, thanks!

Reviewed-and-tested-by: Leah Rumancik <leah.rumancik@gmail.com>
