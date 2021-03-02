Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B62DC43142
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190C8601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343602AbhCCDQJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2361015AbhCBXLL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 18:11:11 -0500
X-Greylist: delayed 88076 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 Mar 2021 15:00:25 PST
Received: from vera.ghen.be (vera.ghen.be [IPv6:2a02:2308:20::3be:0:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9627CC06178B
        for <linux-xfs@vger.kernel.org>; Tue,  2 Mar 2021 15:00:25 -0800 (PST)
Received: by vera.ghen.be (Postfix, from userid 1000)
        id 4Dqsw23GXyz2xBF; Tue,  2 Mar 2021 23:57:22 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hendrickx.be;
        s=21e; t=1614725842;
        bh=l1vW9JHsSOPKj8U7zv7CvTh8KRM1+FD5TUVhL3BnVmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=y+7CgVxOx8pS5Mj03WfCNlOZ8DsHTL3jaWjE1xDRidb9ST14l/JDAFdl6AI5uoNR/
         wnP2e3qmBYbZ6ZSWWo0Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hendrickx.be; s=21r;
        t=1614725842; bh=l1vW9JHsSOPKj8U7zv7CvTh8KRM1+FD5TUVhL3BnVmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=IhNL17XYUM6JT4QyOCC8L6FEQd1Cg9z7lpHOrlZHNxCWIiwy8Ky2HEbLhP/RfcBXf
         uUG5hXB/KeNS+TOAgLH2VGsWaxR+J5qBML/VWzmZ3h985NXVNnQp1J8hpDzRciLkW/
         xvrKiwLnJvznOrOU3854edAAnLV8B+RxNqDpMuVf/3zl0MxxtXFdxFAS5sq0gTTCoy
         ysDlz+7rhPgEGhV0jMLQ6GLNvd47/l3wtM3idDVLk5JisKD1hsJQ5rMZczxsneOq2k
         caiF1+L2KTs/yqVDmKnIuzrLuc+GAYgdT14mejax2nF7VCpmK99E8K5Y1jDZBU8fV5
         QcHsDlFo1mjrQ==
Date:   Tue, 2 Mar 2021 23:57:22 +0100
From:   Geert Hendrickx <geert@hendrickx.be>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_admin -O feature upgrade feedback
Message-ID: <YD7C0v5rKopCJvk2@vera.ghen.be>
References: <YDy+OmsVCkTfiMPp@vera.ghen.be>
 <20210301191803.GE7269@magnolia>
 <YD4tWbfzmuXv1mKQ@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD4tWbfzmuXv1mKQ@bfoster>
X-PGP-Key: https://geert.hendrickx.be/pgpkey.asc
X-PGP-Key-Id: C88C1D9ED3861005886BF44ACD718C1F95AD44EA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 07:19:37 -0500, Brian Foster wrote:
> It's not clear to me if you're reporting that feature upgrades spuriously
> report this "Conversion failed ..." message (i.e., feature upgrade
> succeeded, but repair found and fixed things expected to be problems due
> to the feature upgrade), or that this error is reported if there is
> something independently wrong with the fs. If the former, that seems like
> a bug. If the latter, I think that's reasonable/expected behavior.



There are sillier scenarios, like simply incorrect arguments.  For example
"xfs_admin -O bigtypo=1 /dev/foo" responds with: "Conversion failed, is the
filesystem unmounted?"

(where /dev/foo is the correct blockdevice, properly unmounted etc, but the
options argument contains a typo)

The proper xfs_repair error "unknown option -c bigtypo=1" gets thrown away.


Other examples include "-O bigtime" => "bigtime requires a parameter" (with
Darrick's patch for the other issue applied), or "bigtime=0" => "bigtime
only supports upgrades", all dropped on the floor by xfs_admin and replaced
with the one generic message that gives no indication of the actual problem.
(the user keeps verifying whether the filesystem is unmounted and clean...)



	Geert


