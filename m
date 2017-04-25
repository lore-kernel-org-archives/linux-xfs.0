Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43891 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S978422AbdDYCwM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 22:52:12 -0400
Date: Tue, 25 Apr 2017 04:52:10 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/12] mkfs: save user input into opts table
Message-ID: <20170425025210.GG28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170423185503.31415-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Apr 23, 2017 at 08:54:51PM +0200, Jan Tulak wrote:
> Hi guys,
> 
> I decided to split my big patchset into more smaller ones. So, this is the
> first set. It adds set/get functions similar to Dave's suggestion, to save and
> retrieve user values to and from the big opts table and prepares the ground for
> future patches.
> 
> 
> It is a mix of patches I already submitted and new ones:
> Patches 2, 3, 4, 5 are just slightly modified to fix their issues.
> Other patches are new.
> 
> The last few patches could be merged into one, because it should only
> substitute variables for get/set calls, but because there are so many
> places where the changes occurs, I split them into smaller chunks,
> making it (hopefully) easier for you to review.
> 
> This patchset requires my two previous uint patches.
> Git tree: https://github.com/jtulak/xfsprogs-dev/tree/setters

Consider patches 1-3 Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>
Feedback will be provided on patch 4.

  Luis
