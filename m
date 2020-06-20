Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6038AC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 02:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46213229CA
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 02:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbgFTCgX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 22:36:23 -0400
Received: from p10link.net ([80.68.89.68]:44080 "EHLO P10Link.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731772AbgFTCgX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jun 2020 22:36:23 -0400
Received: from [192.168.1.2] (unknown [94.2.179.121])
        by P10Link.net (Postfix) with ESMTPSA id B1E3440C004;
        Sat, 20 Jun 2020 03:36:21 +0100 (BST)
Subject: Re: Bug#953537: xfsdump fails to install in /usr merged system.
To:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org, 953537@bugs.debian.org
References: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
 <20200619044734.GB11245@magnolia>
 <ea662f0b-7e73-0bbe-33aa-963389b9e215@sandeen.net>
From:   peter green <plugwash@p10link.net>
Message-ID: <99f03015-a962-09fd-7e89-579e130e3a2d@p10link.net>
Date:   Sat, 20 Jun 2020 03:36:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ea662f0b-7e73-0bbe-33aa-963389b9e215@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Putting the Debian bug back in cc, for earlier mails please see https://marc.info/?l=linux-xfs&m=159253950420613&w=2
Eric Sandeen wrote:
> 
> How does debian fix this for xfsprogs?  Doesn't the same issue exist?


I'm not seeing any cases like xfsdump where a binary is located in /sbin but symlinked from /usr/sbin .

Debian merged-usr systems can deal with files in /sbin and files in /usr/sbin, what needs special
treatment is filenames that exist in both.
