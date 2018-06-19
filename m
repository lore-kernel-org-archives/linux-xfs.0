Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030407AbeFSUDD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 16:03:03 -0400
Date: Tue, 19 Jun 2018 22:03:02 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] mkfs: explicitly warn about unknown token failures
Message-ID: <20180619200302.GF7508@wotan.suse.de>
References: <1b2f2674-d6ef-4354-057e-f476ac2e2a83@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b2f2674-d6ef-4354-057e-f476ac2e2a83@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 18, 2018 at 02:29:47PM -0500, Eric Sandeen wrote:
> Rather than a generic "Error parsing line" for an unknown token
> within a section, issue a more helpful error message, i.e.
> 
> [data]
> foo=1
> 
> would yield:
> 
> Invalid token in section [data] at line /etc/xfs/mkfs/default:2 : foo
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>

  Luis
