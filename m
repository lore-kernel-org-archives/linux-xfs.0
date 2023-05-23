Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA48C7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 18:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbjEWSK7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 14:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjEWSK7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 14:10:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC05F97
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 11:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80FA9611B2
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 18:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4CFC433D2;
        Tue, 23 May 2023 18:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684865456;
        bh=+VSWjy9jx66w/zC7RfMNrBUfAdZ+JAkBnQZZ2H9EWM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XhxrrJdysqJOf1nOV/03L2ebUYSwM0KLysnrzrETx8EzAq4wbvRMB79oZHTCeEWHG
         Aat29rdF2vjLOa0wcorYk+QMj9yx2FbDhgqrcJHi5vFNDT0pHuIZL6G/O2mq5AwExs
         H63Kk9/vnUiogXHjPx4euIwSqAA5ST9bjw8HflQqGSmz2rENylVrk3YFPwnnEvyMo8
         isvKYjXTTpso0PRPheY6Ph6DN8IfQSei2TJrIPDdAicorGvZkcJAKPltGfqOaHB6yD
         JFTQlQ1Vay8ppt5ggipTQoxZNzkRO7wFlZA8fFRklPNF/jW+zuS25EhdBqsa3WuK8O
         tkeVXC9LfPnkQ==
Date:   Tue, 23 May 2023 11:10:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/24] xfs_mdrestore.8: Add description for the newly
 introduced -l option
Message-ID: <20230523181056.GD11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-25-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-25-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:50PM +0530, Chandan Babu R wrote:
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  man/man8/xfs_mdrestore.8 | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
> index 72f3b2977..a53ac84d0 100644
> --- a/man/man8/xfs_mdrestore.8
> +++ b/man/man8/xfs_mdrestore.8
> @@ -5,6 +5,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
>  .B xfs_mdrestore
>  [
>  .B \-gi
> +] [
> +.B \-l
> +.I logdev
>  ]
>  .I source
>  .I target
> @@ -49,6 +52,11 @@ Shows metadump information on stdout.  If no
>  is specified, exits after displaying information.  Older metadumps man not
>  include any descriptive information.
>  .TP
> +.B \-l " logdev"
> +Metadump in v2 format can contain metadata dumped from an external log. In
> +such a scenario, the user has to provide a device to which the log device
> +contents from the metadump file are copied.

Please start sentences on a new line.

Also, this ought to be folded into the previous patch.

Otherwise the manpage additions look reasonable to me.

--D

> +.TP
>  .B \-V
>  Prints the version number and exits.
>  .SH DIAGNOSTICS
> -- 
> 2.39.1
> 
