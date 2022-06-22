Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29F7C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 21:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiFVVwW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 17:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241606AbiFVVwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 17:52:22 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE553F885;
        Wed, 22 Jun 2022 14:52:21 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f65so17295661pgc.7;
        Wed, 22 Jun 2022 14:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ff+wSWRYawbYfja79/+Q0GxbRwkAY28J1KvnmTXQcGQ=;
        b=iWxFDNSkzu7gFgbVNuHDVIsKXZtpFHWIuQ+o3+ZZiC6moXjThRf6oAql8TUWrnvp2+
         PRjCZeT+bbMs1SMzESye1avCIJhEESWo4kYaJIPsMrSKXaFpQM1AVh30q25VmUv6B+R7
         RV5s/kGPJi8q750G0NEHG7ATHrG4b2sTzZd5o0EumEIBp4b+L6R5Yzk67xm+YDDzONfF
         YcvxbVOogtUTzOXZLvDqwQ09S5DMLRneeDbMyifKs1vw52qbPL16n6wr7NU4JFbJc9nG
         /DxNzXkM5AhCjOjdQl/y8sPBA9QU0zHcPghPxcNetX1lnf2eccUIlaj8Yg7D/xuhoSIS
         c0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ff+wSWRYawbYfja79/+Q0GxbRwkAY28J1KvnmTXQcGQ=;
        b=RqgiQu/8DhRvyBa4GTq3OShhZVFwqgZCRVBggoLuiLGi26WZzQ4TnDJjD6IqRQVsrr
         ZgVmIHpAxGowJ/ZNv0vzRasMWXX0v+nfmSAGQ7MAuoXXoi+hIqLwKIW7TdfyuTikmcoV
         XYx6W3JpNsS8RFutMD2aDjwtSDwbuYFAgDplH7W3BHrMU7vFu7atpOK7tBpnNoE6DGaW
         Ess1XPLvUeFweQSj5MK59rLCImMQtsp4Dm5c0TXZFxIRHx7mm6A7AG4BUg7nA9aQ9yZZ
         bVY+tJ8jKjBbKBhbhBeN6X8wwnc1xtzcQtC7cBVDecc8LpJ38q9ymY2MP6eQQKK4H40g
         pV9w==
X-Gm-Message-State: AJIora/7slWBnkNYtM4QRjdcs8IjWOJug2rrfkoMN56R35H5fTAB3NJS
        3GsekrX/BK8RCAgn7wdvOt4=
X-Google-Smtp-Source: AGRyM1vmA9dX0M+nQ7wLacmp7GzLzdAeLMP8qytUaPVHKQNaCvsm7K8dG20FKReh6MWIkt3E7JlVMw==
X-Received: by 2002:aa7:81c1:0:b0:522:81c0:a646 with SMTP id c1-20020aa781c1000000b0052281c0a646mr37243211pfn.33.1655934740941;
        Wed, 22 Jun 2022 14:52:20 -0700 (PDT)
Received: from google.com ([2620:0:1001:7810:1c61:ca22:3ef4:fce9])
        by smtp.gmail.com with ESMTPSA id o10-20020a17090ac08a00b001ec79f0da37sm267923pjs.14.2022.06.22.14.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 14:52:20 -0700 (PDT)
Date:   Wed, 22 Jun 2022 14:52:18 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>, linux-xfs@vger.kernel.org,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrOPEnO8hufMiRMi@google.com>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrJdLhHBsolF83Rq@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 21, 2022 at 05:07:10PM -0700, Luis Chamberlain wrote:
> On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> > https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 
> 
> The coverage for XFS is using profiles which seem to come inspired
> by ext4's different mkfs configurations.
The configs I am using for the backports testing were developed with
Darrick's help. If you guys agree on a different set of configs, I'd be
happy to update my configs moving forward. As there has been testing of
these patches on both 5.10 with those configs as well as on 5.15 with
my configs, I don't think this should be blocking for this set of
patches.

- Leah
> 
> Long ago (2019) I had asked we strive to address popular configurations
> for XFS so that what would be back then oscheck (now kdevops) can cover
> them for stable XFS patch candidate test consideration. That was so long
> ago no one should be surprised you didn't get the memo:
> 
> https://lkml.kernel.org/r/20190208194829.GJ11489@garbanzo.do-not-panic.com
> 
> This has grown to cover more now:
> 
> https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstests/templates/xfs/xfs.config
> 
> For instance xfs_bigblock and xfs_reflink_normapbt.
> 
> My litmus test back then *and* today is to ensure we have no regressions
> on the test sections supported by kdevops for XFS as reflected above.
> Without that confidence I'd be really reluctant to support stable
> efforts.
> 
> If you use kdevops, it should be easy to set up even if you are not
> using local virtualization technologies. For instance I just fired
> up an AWS cloud m5ad.4xlarge image which has 2 nvme drives, which
> mimics the reqs for the methodology of using loopback files:
> 
> https://github.com/linux-kdevops/kdevops/blob/master/docs/seeing-more-issues.md
> 
> GCE is supported as well, so is Azure and OpenStack, and even custom
> openstack solutions...
> 
> Also, I see on the above URL you posted there is a TODO in the gist which
> says, "find a better route for publishing these". If you were to use
> kdevops for this it would have the immediate gain in that kdevops users
> could reproduce your findings and help augment it.
> 
> However if using kdevops as a landing home for this is too large for you,
> we could use a new git tree which just tracks expunges and then kdevops can
> use it as a git subtree as I had suggested at LSFMM. The benefit of using a
> git subtree is then any runner can make use of it. And note that we
> track both fstests and blktests.
> 
> The downside is for kdevops to use a new git subtree is just that kdevops
> developers would have to use two trees to work on, one for code changes just
> for kdevops and one for the git subtree for expunges. That workflow would be
> new. I don't suspect it would be a really big issue other than addressing the
> initial growing pains to adapt. I have used git subtrees before extensively
> and the best rule of thumb is just to ensure you keep the code for the git
> subtree in its own directory. You can either immediately upstream your
> delta or carry the delta until you are ready to try to push those
> changes. Right now kdevops uses the directory workflows/fstests/expunges/
> for expunges. Your runner could use whatever it wishes.
> 
> We should discuss if we just also want to add the respective found
> *.bad, *.dmesg *.all files for results for expunged entries, or if
> we should be pushing these out to a new shared storage area. Right now
> kdevops keeps track of results in the directory workflows/fstests/results/
> but this is a path on .gitignore. If we *do* want to use github and a
> shared git subtree perhaps a workflows/fstests/artifacts/kdevops/ would
> make sense for the kdevops runner ? Then that namespace allows other
> runners to also add files, but we all share expunges / tribal knowledge.
> 
> Thoughts?
> 
>   Luis
