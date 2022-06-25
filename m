Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03455C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jun 2022 02:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiFYCWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 22:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiFYCWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 22:22:14 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E50D43483;
        Fri, 24 Jun 2022 19:22:10 -0700 (PDT)
Received: from letrec.thunk.org (c-24-1-67-28.hsd1.il.comcast.net [24.1.67.28])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 25P2LofN025209
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 22:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1656123714; bh=AEyZR8AOB6LkvhahSPbOkR58lYNnzoQieY4ZJ0ENr/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=GDFWwuS/iT213UvJn0J1caujUmQrMhBFKAO/axHMXX6hMI3tXiN6R/s0ifuzUaA7C
         +X2sAN67EJ647Icq9RFvIqrXuLoqxi4Q5Go5SWxJTqad6iiTu3E93DTNvEJuYAZlHG
         0RYQpibnXPKWNHBel9cAhgjjSFWOTq/tGbTrauGZUkgBa3OSa/bQlEAFfgt69QrghU
         83Pho85WTCghS9gk5oRHRUgeZGgX3qXbNmxRdvoHBjxLeE6LJO5ULC2M8JOsU1WevY
         nv2wkLtaWS9OpRfGjo0PK7kaBQ77A3FSBXkANwRLW3YmAzZytulF9/jdLIE6keo3GL
         ejmCWUPLu5RYA==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id 766C88C3495; Fri, 24 Jun 2022 22:21:50 -0400 (EDT)
Date:   Fri, 24 Jun 2022 22:21:50 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrZxPlTQ9f/BvnkJ@mit.edu>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
 <YrVMZ7/rJn11HH92@mit.edu>
 <YrZAtOqQERpYbBXg@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrZAtOqQERpYbBXg@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 24, 2022 at 03:54:44PM -0700, Luis Chamberlain wrote:
> 
> Perhaps I am not understanding what you are suggesting with a VM native
> solution. What do you mean by that? A full KVM VM inside the cloud?

"Cloud native" is the better way to put things.  Cloud VM's
are designed to be ephemeral, so the concept of "node bringup" really
doesn't enter into the picture.

When I run the "build-appliance" command, this creates a test
appliance image.  Which is to say, we create a root file system image,
and then "freeze" it into a VM image.

For kvm-xfstests this is a qcow image which is run in snapshot mode,
which means that if any changes is made to the root file system, those
changes disappear when the VM exits.

For gce-xfstests, we create an image which can be used to quickly
bring up a VM which contains a block device which contains a copy of
that image as the root file system.  What so special about this?  I
can create a dozen, or a hundred VM's, all with a copy of that same
image.  So I can do something like

   gce-xfstests ltm -c ext4/all -g full gs://gce-xfstests/bzImage-5.4.200

and this will launch a dozen VM's, with each VM testing a single test
configuration with the kernel found at gs://gce-xfstests/bzImage-5.4.200
in Google Cloud Storage GCS (the rough equivalent of AWS's S3).

And then I can run

   gce-xfstests ltm -c ext4/all -g full --repo stable.git --commit v5.10.124

And this will launch a build VM which is nice and powerful to
*quickly* build the 5.10.124 kernel as found in the stable git tree,
and then launch a dozen additional VM's to test that built kernel
against all of the test configs defined for ext4/all, one VM per each
fs config.

And after running

   gce-xfstests ltm -c ext4/all -g full --repo stable.git --commit v5.15.49
   gce-xfstests ltm -c ext4/all -g full --repo stable.git --commit v5.18.6

... now there will be ~50 VM's all running tests in parallel.  So this
is far faster than doing a "node bringup", and since I am running all
of the tests in parallel, I will get the test results back in a much
shorter amount of wall clock time.  And, as running each test config
complete, the VM's will disappear (after first uploading the test
results into GCS), and I will stop getting charged for them.

And if I were to launch additional tests runs, each containing their
own set of VM's:

   gce-xfstests ltm -c xfs/all -g full --repo stable.git --commit v5.15.49
   gce-xfstests ltm -c xfs/all -g full --repo stable.git --commit v5.18.6
   gce-xfstests ltm -c f2fs/all -g full --repo stable.git --commit v5.15.49

I can very quickly have over 100 test VM's running in parallel, and as
the tests complete, they are automatically shutdown and destroyed ----
which means that we don't store state in the VM.  Instead the state is
stored in a Google Cloud Storage (Amazon S3) bucket, with e-mail sent
with a summary of results.

VM's can get started much more quickly than "make bringup", since
we're not running puppet or ansible to configure each node.  Instead,
we get a clone of the test appliance:

% gce-xfstests describe-image
archiveSizeBytes: '1315142848'
creationTimestamp: '2022-06-20T21:46:24.797-07:00'
description: Linux Kernel File System Test Appliance
diskSizeGb: '10'
family: xfstests
  ...
labels:
  blktests: gaf97b55
  fio: fio-3_30
  fsverity: v1_5
  ima-evm-utils: v1_3_2
  nvme-cli: v1_16
  quota: v4_05-43-gd2256ac
  util-linux: v2_38
  xfsprogs: v5_18_0
  xfstests: v2022_06_05-13-gbc442c4b
  xfstests-bld: g8548bd11
  zz_build-distro: bullseye
  ...

And since these images are cheap to keep around (5-6 cents/month), I
can keep a bunch of older versions of test appliances around, in case
I want to see if a test regression might be caused by a newer version
of the test appliance.  So I can run "gce-xfstests -I
xfstests-202001021302" and this will create a VM using the test
appliance that I built on January 2, 2020.  It also means that I can
release a new test appliance to the xfstests-cloud project for public
use, and if someone wants to pin their testing to an known version of
the test appliance, they can do that.

So the test appliance VM's can be much more dynamic than kdevops
nodes, because they can be created and deleted without a care in the
world.  This is enabled by the fact that there isn't any state which
is stored on the VM.  In contrat, in order to harvest test results
from a kdevops node, you have to ssh into the node and try to find the
test results.

In contrast, I can just run "gce-xfstests ls-results" to see all of
the results that has been saved to GCS, and I can fetch a particular
test result to my laptop via a single command: "gce-xfstests
get-results tytso-20220624210238".  No need to ssh to a host node, and
then ssh to the kdevops test node, yadda, yadda, yadda --- and if you
run "make destroy" you lose all of the test result history on that node,
right?

Speaking of saving the test result history, a full set of test
results/artifiacts for a dozen ext4 configs is around 12MB for the
tar.xz file, and Google Cloud Storage is a penny/GB/month for nearline
storage, and 0.4 cents/GB/month for coldline storage, so I can afford
to keep a *lot* of test results/artifacts for quite a while, which can
occasionally be handy for doing some historic research.


See the difference?

						- Ted
