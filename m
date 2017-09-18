Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750710AbdIRHrR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:47:17 -0400
Date: Mon, 18 Sep 2017 09:47:13 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170918074713.5lravsj234d5pbdj@linux-x5ow.site>
References: <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard>
 <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
 <20170914004038.GZ10621@dastard>
 <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
 <x49a81xeakx.fsf@segfault.boston.devel.redhat.com>
 <20170914131638.qxbzeocvrkhjcjcu@linux-x5ow.site>
 <CAPcyv4j4GUjQBa7ePUGLuHjZcf3G+0suvc7r6wmgGM_G_L5Gcw@mail.gmail.com>
 <20170915091845.pmp3wer5lwx2xhjz@linux-x5ow.site>
 <CAA9_cmdrV13OgnRxpd0W9yYGBm4XP=fdTHDZvCBk4YR7gt8M5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA9_cmdrV13OgnRxpd0W9yYGBm4XP=fdTHDZvCBk4YR7gt8M5g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, Sep 15, 2017 at 10:39:05AM -0700, Dan Williams wrote:
> Yes, but what we're worried about in the libnvdimm/nfit_test case is
> internals behind sysfs interfaces. But point taken, we can at least
> use the presence of certain attributes to gate tests. However, it does
> mean we lose the tests for when an attribute is missing due to an
> incomplete backport.

Of cause, but all we loose is a group of testcases to be run and this can be
an indication of a bad backport as well, so I think this is quite helpful.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
