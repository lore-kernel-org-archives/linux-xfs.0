Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53330C43381
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 17:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A280230FC
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 17:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391614AbhALRvr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391608AbhALRvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 12:51:47 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F147FC061795
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 09:51:06 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1kzNov-0002iD-98; Tue, 12 Jan 2021 17:51:05 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#979653: xfsprogs: Incomplete debian/copyright
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 979653@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 979653
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: 
References: <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <59b797fa-21b2-b733-88b2-81735bc7d2f5@fishpost.de> <a7a0a016-c031-4532-1292-ad12d16415cf@sandeen.net> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <793e1519-b3d9-db3e-4a71-bb6da8ff2ff2@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de>
X-Debian-PR-Source: xfsprogs
Received: via spool by 979653-submit@bugs.debian.org id=B979653.16104736078400
          (code B ref 979653); Tue, 12 Jan 2021 17:51:04 +0000
Received: (at 979653) by bugs.debian.org; 12 Jan 2021 17:46:47 +0000
Received: from mail.kernel.org ([198.145.29.99]:38294)
        by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <djwong@kernel.org>)
        id 1kzNkk-0002BC-Af
        for 979653@bugs.debian.org; Tue, 12 Jan 2021 17:46:47 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id B586622CE3;
        Tue, 12 Jan 2021 17:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610473604;
        bh=2Y17WBbbG78ojmHMmvEScRtY7PMTmViXrZvM01Ki/ZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJ2avJPxASRMJi+P6Sr7ElCNFa7n4aLQQLVyjDmnRMCwcJ8luV0XQDlApfWkhBC5Y
         6bexdHEVePj/1hoW7yZ6Z7PbtpThc+98hjhEGcRlwAgCsTLd2dvn6WPT6P96r4hUGi
         T2+tLpv/EVAPj7QRGJno7JgP+7nFKy1hpXwGFO65sEGI4J4O3Qb6e1MS/AJifebnop
         98Bx2uQTTY47H1NuHzq/MvVRZi2ZICO77juYbphgZQs8hV4DyNcjDzkxpGZUXzXKzl
         F5qTI6pN58iPxq2jH3V6U1Jp36nyBSwr/DDmaV+3ka1XDpiPfXJrAuCUVrITR4jlMT
         FP2apqUyhj7FA==
Date:   Tue, 12 Jan 2021 09:46:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>,
        979653@bugs.debian.org
Cc:     Eric Sandeen <sandeen@sandeen.net>
Message-ID: <20210112174644.GR1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <793e1519-b3d9-db3e-4a71-bb6da8ff2ff2@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 10, 2021 at 01:23:58AM +0100, Bastian Germann wrote:
> Am 09.01.21 um 23:53 schrieb Eric Sandeen:
> > On 1/9/21 2:42 PM, Bastian Germann wrote:
> > > On Sat, 9 Jan 2021 19:31:50 +0100 Bastian Germann <bastiangermann@fishpost.de> wrote:
> > > > xfsprogs' debian/copyright only mentions Silicon Graphics, Inc.'s copyright. There are other copyright holders, e.g. Oracle, Red Hat, Google LLC, and several individuals. Please provide a complete copyright file and convert it to the machine-readable format.
> > > 
> > > Please find a copyright file enclosed.
> > 
> > Hi Bastian -
> > 
> > I'll take an update to this file, but what are the /minimum/ requirements
> > per Debian policy?
> 
> https://www.debian.org/doc/debian-policy/ch-archive.html#copyright-considerations
> 
> The minimum requirements are that you include the license info.
> The copyright info also has to be included in some cases, essentially for
> each file that is included in compiled form in a binary package you have to
> reproduce its copyright info if the license requires the copyright to be
> retained in binary distributions.
> 
> > 
> > Tracking everything by file+name(s)+year seems rather pointless - it's all
> > present in the accompanying source, and keeping it up to date at this
> > granularity seems like make-work doomed to be perpetually out of sync.
> 
> You can get rid of all the file names. The license info has to be included
> (GPL-2, LGPL-2.1, GPL-3+ with autoconf exception). One can argue that the
> FSF unlimited permission license text (m4/*) also has to be included by
> Policy.
> 
> The (L)GPL requires the copyright statements to be included.
> 
> I have reduced the given copyright file to a more maintainable version. It
> still keeps some file names (not required) so that one can identify the
> primary copyright holders and the LGPL parts easily.
> 
> > I'd prefer to populate it with the minimum required information in
> > order to minimize churn and maximize ongoing correctness if possible.
> > 
> > Thanks,
> > -Eric
> > 

> Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
> Upstream-Name: xfsprogs
> Comment: This package was debianized by Nathan Scott <nathans@debian.org>
> Source: https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/
> 
> Files: *
> Copyright:
>  1995-2013 Silicon Graphics, Inc.
>  2010-2018 Red Hat, Inc.
>  2016-2020 Oracle.  All Rights Reserved.

/me notes that a lot of the Oracle-copyright files are actually GPL-2+,
not GPL-2.  That might not be obvious because I bungled some of the SPDX
tags when spdx deprecated the "GPL-2.0+" tag and we had to replace them
all with "GPL-2.0-or-later", though it looks like they've all been
cleaned up at this point.

Question: How can we autogenerate debian/copyright from the source files
in the git repo?  In the long run I think it best that this becomes
something we can automate when tagging a new upstream release.

--D

> Comment: For most files, only one of the copyrights applies.
> License: GPL-2
> 
> Files:
>  libhandle/*.c
> Copyright: 1995, 2001-2002, 2005 Silicon Graphics, Inc.
> Comment: This also applies to some header files.
> License: LGPL-2.1
>  This library is free software; you can redistribute it and/or modify it
>  under the terms of the GNU Lesser General Public License as published by
>  the Free Software Foundation; version 2.1 of the License.
>  .
>  This library is distributed in the hope that it will be useful, but WITHOUT
>  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
>  for more details.
>  .
>  On Debian systems, refer to /usr/share/common-licenses/LGPL-2.1
>  for the complete text of the GNU Lesser General Public License.
> 
> Files: config.*
> Copyright: 1992-2013 Free Software Foundation, Inc.
> License: GPL-3+ with autoconf exception
>  This file is free software; you can redistribute it and/or modify it
>  under the terms of the GNU General Public License as published by
>  the Free Software Foundation; either version 3 of the License, or
>  (at your option) any later version.
>  .
>  This program is distributed in the hope that it will be useful, but
>  WITHOUT ANY WARRANTY; without even the implied warranty of
>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>  General Public License for more details.
>  .
>  You should have received a copy of the GNU General Public License
>  along with this program; if not, see <http://www.gnu.org/licenses/>.
>  .
>  As a special exception to the GNU General Public License, if you
>  distribute this file as part of a program that contains a
>  configuration script generated by Autoconf, you may include it under
>  the same distribution terms that you use for the rest of that
>  program.  This Exception is an additional permission under section 7
>  of the GNU General Public License, version 3 ("GPLv3").
>  .
>  On Debian systems, the full text of the GNU General Public License version 3
>  License can be found in /usr/share/common-licenses/GPL-3 file.
> 
> Files: io/copy_file_range.c
> Copyright: 2016 Netapp, Inc. All rights reserved.
> License: GPL-2
> 
> Files: io/encrypt.c
> Copyright: 2016, 2019 Google LLC
> License: GPL-2
> 
> Files:
>  io/link.c
>  libxfs/xfs_iext_tree.c
> Copyright: 2014, 2017 Christoph Hellwig.
> License: GPL-2
> 
> Files: io/log_writes.c
> Copyright: 2017 Intel Corporation.
> License: GPL-2
> 
> Files: io/utimes.c
> Copyright: 2016 Deepa Dinamani
> License: GPL-2
> 
> Files: libfrog/radix-tree.*
> Copyright:
>  2001 Momchil Velikov
>  2001 Christoph Hellwig
>  2005 SGI, Christoph Lameter <clameter@sgi.com>
> License: GPL-2
> 
> Files: libxfs/xfs_log_rlimit.c
> Copyright: 2013 Jie Liu.
> License: GPL-2
> 
> License: GPL-2
>  This program is free software; you can redistribute it and/or modify it under
>  the terms of the GNU General Public License as published by the Free Software
>  Foundation; version 2 of the License.
>  .
>  This program is distributed in the hope that it will be useful, but WITHOUT
>  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
>  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
>  .
>  You should have received a copy of the GNU General Public License along with
>  this package; if not, write to the Free Software Foundation, Inc., 51 Franklin
>  St, Fifth Floor, Boston, MA  02110-1301 USA
>  .
>  On Debian systems, the full text of the GNU General Public License version 2
>  License can be found in /usr/share/common-licenses/GPL-2 file.
