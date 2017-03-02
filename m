Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34259 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbdCBQsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2017 11:48:22 -0500
Date: Thu, 2 Mar 2017 07:47:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mm allocation failure and hang when running xfstests generic/269
 on xfs
Message-ID: <20170302154725.GA28457@infradead.org>
References: <20170302103520.GC1404@dhcp22.suse.cz>
 <20170302122426.GA3213@bfoster.bfoster>
 <20170302124909.GE1404@dhcp22.suse.cz>
 <20170302130009.GC3213@bfoster.bfoster>
 <20170302132755.GG1404@dhcp22.suse.cz>
 <20170302134157.GD3213@bfoster.bfoster>
 <20170302135001.GI1404@dhcp22.suse.cz>
 <20170302142315.GE3213@bfoster.bfoster>
 <20170302143441.GL1404@dhcp22.suse.cz>
 <20170302145131.GF3213@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302145131.GF3213@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Mar 02, 2017 at 09:51:31AM -0500, Brian Foster wrote:
> Otherwise, I'm fine with breaking the infinite retry loop at the same
> time. It looks like Christoph added this function originally so this
> should probably require his ack as well..

I just moved the code around, but I'll take a look as well.
