Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37182 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbeCUAPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 20:15:01 -0400
Date: Tue, 20 Mar 2018 17:14:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC] xfsprogs: remove irix, darwin, freebsd support
Message-ID: <20180321001456.GM1757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>

Hi all,

This is a metapatch proposing that we drop all the non-Linux xfsprogs
ports.

Irix hasn't had a release since August 2006.

OSX doesn't support XFS and (afaict) never has.

FreeBSD EOL'd v9.3 (which was the last one to support XFS) in January
2017.

So, can we git rm {include,libxfs}/{irix,darwin,freebsd}.[ch] ?

--D
