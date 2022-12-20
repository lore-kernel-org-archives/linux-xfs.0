Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19277C001B2
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 03:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiLTDaS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 22:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiLTDaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 22:30:16 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C022AF3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 19:30:15 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BK3Tw0h031574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 22:30:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671507002; bh=Qf6faypoXHGg6tawwxUgy9DzZhgNXLnAIn3mummMjhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=gwomMzzH9z/BJ3PA7iMzZGRkjs/VohjHIgJ34dIuCg3pLdNvDDxNHxzRp15fyA8+X
         nfXzyRgsBwYkPQ2NWtfLqa4QRIiEmOTVDjL41k8olr8C9gBm+IpAXU2UP+OIMRIU7Z
         YqnMVSsHDaPxT7wwMrVZa5gzt2F8+Qo8QYXOzwmykYlwKnWlCAc3npSMygf8th9mOk
         NkC1gnLjOUJzJFALY+C9X5KAKAGgUUh29BfQJzD6jey1LKuAfZ3xd8A6+ObHf7surc
         2mc4840R3U3RjoCOBN9+KlzskRdiMLdkkYgP5LlKkdt7i4Lgf8wKD9pYHGrRACKwUt
         Lf3Vd+GijTppA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 523BB15C3511; Mon, 19 Dec 2022 22:29:58 -0500 (EST)
Date:   Mon, 19 Dec 2022 22:29:58 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, leah.rumancik@gmail.com,
        quwenruo.btrfs@gmx.com
Subject: Re: [PATCH 6/8] report: collect basic information about a test run
Message-ID: <Y6EsNkIcA7bd9aHR@mit.edu>
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149449737.332657.1308561091226926848.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167149449737.332657.1308561091226926848.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 19, 2022 at 04:01:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Record various generic information about an fstests run when generating
> a junit xml report.  This includes the cpu architecture, the kernel
> revision, the CPU, memory, and numa node counts, and some information
> about the block devices passed in.

It would be nice if there was a way that the test runner could pass
information that would be added to the xunit properties.  As I
mentioned in another e-mail, I currently do this via a post-processing
step which adds the properties to the junit xml file via a python
script.  And there are a number of additional properties that are used
by my report generator[1] which takes the junit xml file as input, and
generates a summary report which is convenient for humans.

[1] https://github.com/tytso/xfstests-bld/blob/master/test-appliance/files/usr/local/bin/gen_results_summary

Some of these properties include the version of xfstests, xfsprogs,
and other key software components (for example, I've had test failures
traced to bugs in fio, so knowing the version of fio that is used is
super-handy).

So maybe we could pass in a properties file, either via a command-line
option or an environment variable?  My script[2] uses a colon
separated format, but I'm not wedded to that delimiter.

CMDLINE: "-c f2fs/default -g auto"
FSTESTIMG: gce-xfstests/xfstests-amd64-202212131454
FSTESTPRJ: gce-xfstests
KERNEL: kernel	6.1.0-xfstests #2 SMP PREEMPT_DYNAMIC Mon Dec 12 16:09:40 EST 2022 x86_64
FSTESTVER: blktests	068bd2a (Fri, 18 Nov 2022 08:38:35 +0900)
FSTESTVER: fio		fio-3.31 (Tue, 9 Aug 2022 14:41:25 -0600)
FSTESTVER: fsverity	v1.5 (Sun, 6 Feb 2022 10:59:13 -0800)
FSTESTVER: ima-evm-utils	v1.3.2 (Wed, 28 Oct 2020 13:18:08 -0400)
FSTESTVER: nvme-cli	v1.16 (Thu, 11 Nov 2021 13:09:06 -0800)
FSTESTVER: quota		v4.05-52-gf7e24ee (Tue, 1 Nov 2022 11:45:06 +0100)
FSTESTVER: util-linux	v2.38.1 (Thu, 4 Aug 2022 11:06:21 +0200)
FSTESTVER: xfsprogs	v6.0.0 (Mon, 14 Nov 2022 12:06:23 +0100)
FSTESTVER: xfstests-bld	65edab38 (Wed, 30 Nov 2022 12:11:57 -0500)
FSTESTVER: xfstests	v2022.11.27-8-g3c178050c (Wed, 30 Nov 2022 10:25:39 -0500)
FSTESTVER: zz_build-distro	bullseye
FSTESTCFG: "f2fs/default"
FSTESTSET: "-g auto"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "2"
MEM: "7680"
DMI_MEM: 8 GB (Max capacity)
PARAM_MEM: 7680 (restricted by cmdline)
GCE ID: "3198461547210171740"
MACHINE TYPE: "e2-standard-2"
TESTRUNID: tytso-20221213150813

[2] https://github.com/tytso/xfstests-bld/blob/master/test-appliance/files/usr/local/bin/update_properties_xunit

Cheers,

					- Ted
