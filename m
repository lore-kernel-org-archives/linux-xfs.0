Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50344 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S974967AbdDYFaT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 01:30:19 -0400
Date: Tue, 25 Apr 2017 07:30:17 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 08/12] mkfs: replace variables with opts table: -b,d,s
 options
Message-ID: <20170425053017.GM28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-9-jtulak@redhat.com>
 <20170425052721.GL28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170425052721.GL28800@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 07:27:21AM +0200, Luis R. Rodriguez wrote:
> On Sun, Apr 23, 2017 at 08:54:59PM +0200, Jan Tulak wrote:
> > Remove variables that can be replaced with a direct access to the opts table,
> > so we have it all in a single place, acessible from anywhere.
> > 
> > In future, we can remove some passing of values forth and back, but now limit
> > the changes to simple replacement without a change in the logic.

FWIW, patches 9-12 go reviewed with the same topical concern as in this patch.

  Luis
