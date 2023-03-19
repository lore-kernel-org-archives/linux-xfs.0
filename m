Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7300AC7618A
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Mar 2023 00:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCSATg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Mar 2023 20:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCSAS5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Mar 2023 20:18:57 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF9829417
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 17:17:37 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id s8so4930466pfk.5
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 17:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679185027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hTG6T8IcrIzhOp1QcdN1+8G5gk6n0VecZcaFVMzA4MY=;
        b=Z9tgles+3+yRiOSWI8ds0mVhFkpfsbifpWwkeFgpjJ2YrILYby5xSKJlDV6pUlo7Vk
         4yNytS/VZlI7KopNJsrCn8WQ8tludsaZF57+hA3FdmOY9qlIEamhEYHJPmFh8pTeQYD+
         xexRChu4rGYxAWR7uhkzlZfd1WZ6FRpgj2IqjE0PgQBGsEGWFtJxcHyzLXxSBNJMjkk8
         YwZtU8rwfIBDOnMSGvOzUiRlZxn8ZZ1m7CwJo3m4tq4n+6I1DBFCGH7SU5dH3U64R70j
         vfXfmO4/Ta18bytoKLjB2c3DjA4BUh++hkgtaDB3XHvQjt8gaH2VwdpT+qZBTI7QYU47
         +hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679185027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTG6T8IcrIzhOp1QcdN1+8G5gk6n0VecZcaFVMzA4MY=;
        b=Q75gxxDli6ERWEQcIewl8XQsxlT5MMDUIF55k/3guUNi3hbyoh9EZtIwIJXzHZuvx5
         56kaB1PfIqQ1cKBTAfbgGJ68GhcnpcvsY7uA1WKHM947YSKoyPJNqWqhHV/oFT5Xe2hD
         s10SlLJkGVmYEu5J8xJtKTnx6gUEWvvG96uG1brKRr2AJQ1BinWr/VqemvfBVd00cQfr
         fpcUvrZUrSxTEdcGHh9wxTs2O5X2W2H96tfb5uf+pcnye7rMIkUM9F+LNvQuscTobGef
         D1iH2JgwqNOeK8hLPpz75ZkXuimK0nJ/OaW3Ur1DdVpjw/+138+TZidzPiz2Qqwnzc89
         nAdA==
X-Gm-Message-State: AO0yUKWz5bNUU0MNPBD569LNkp7dzdBkRfVfYLfQv6uluDzK7qwntLa5
        Y7Min7nQd69Nm+rwfvmdccVzBtFWNkQDH+knJWs=
X-Google-Smtp-Source: AK7set8P+EWiLSkoBC4FBP9N8TINYIl8LOkTuhskteqeAtpbdejvTVoUtTO8aNLOV3r8Ph7PN6olyQ==
X-Received: by 2002:aa7:968f:0:b0:625:6e00:210d with SMTP id f15-20020aa7968f000000b006256e00210dmr10602202pfk.21.1679185027226;
        Sat, 18 Mar 2023 17:17:07 -0700 (PDT)
Received: from destitution (pa49-196-94-140.pa.vic.optusnet.com.au. [49.196.94.140])
        by smtp.gmail.com with ESMTPSA id y5-20020aa78045000000b0062606b4ecb3sm3698448pfm.108.2023.03.18.17.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 17:17:06 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pdgjA-000NK4-0J;
        Sun, 19 Mar 2023 11:16:48 +1100
Date:   Sun, 19 Mar 2023 11:16:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1 0/4] setting uuid of online filesystems
Message-ID: <ZBZUcGLcTSgKVXa5@destitution>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
 <20230314062847.GQ360264@dread.disaster.area>
 <953CAB5C-E645-4BB2-88E2-E992C5CC565D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <953CAB5C-E645-4BB2-88E2-E992C5CC565D@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2023 at 08:41:14PM +0000, Catherine Hoang wrote:
> > On Mar 13, 2023, at 11:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Mon, Mar 13, 2023 at 09:21:05PM -0700, Catherine Hoang wrote:
> >> Hi all,
> >> 
> >> This series of patches implements a new ioctl to set the uuid of mounted
> >> filesystems. Eventually this will be used by the 'xfs_io fsuuid' command
> >> to allow userspace to update the uuid.
> >> 
> >> Comments and feedback appreciated!
> > 
> > What's the use case for this?
> 
> We want to be able to change the uuid on newly mounted clone vm images
> so that each deployed system has a different uuid. We need to do this the
> first time the system boots, but after the root fs is mounted so that fsuuid
> can run in parallel with other service startup to minimize deployment times.

Why can't you do it offline immediately after the offline clone of
the golden image? I mean, cloning images and setting up their
contents is something the external orchestration software does
and will always have to do, so i don't really understand why UUID
needs to be modified at first mount vs at clone time. Can you
describe why it actually needs to be done after first mount?

> >>  xfs: add XFS_IOC_SETFSUUID ioctl
> >>  xfs: export meta uuid via xfs_fsop_geom
> > 
> > For what purpose does userspace ever need to know the sb_meta_uuid?
> 
> Userspace would need to know the meta uuid if we want to restore
> the original uuid after it has been changed.

I don't understand why you'd want to restore the original UUID given
the use case you've describe. Can you explain the situation where
you want to return a cloned image to the original golden image UUID?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
