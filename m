Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755010AbeFNQUh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 12:20:37 -0400
Date: Thu, 14 Jun 2018 18:20:36 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 1/2] mkfs: initialize return value of parse_config_stream
 to success
Message-ID: <20180614162036.GB7508@wotan.suse.de>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8318bdfe-ff7b-02b9-414e-f63f9ccdbdbc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8318bdfe-ff7b-02b9-414e-f63f9ccdbdbc@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jun 13, 2018 at 02:34:33PM -0500, Eric Sandeen wrote:
> Right now the return value is initialized to -1 (failure) and set to zero
> only if a valid token is found.  However, this means that i.e. a blank
> or template config file containing only comments will yield failure on
> parsing.
>     
> Initialize to success, and set to failure only if failure occurs.
>     
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>
