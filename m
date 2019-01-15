Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44293 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbfAOP4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 10:56:02 -0500
Received: by mail-pl1-f196.google.com with SMTP id e11so1467009plt.11
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 07:56:02 -0800 (PST)
Date: Tue, 15 Jan 2019 07:55:57 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC PATCH xfstests] xfs: add tests to validate ioctl structure
 layout.
Message-ID: <20190115155557.GA4482@garbanzo.do-not-panic.com>
References: <CADyTPEzrtDwSE9F1Ef+0xJDn4Fh15gDZOwz5J-ySorgM2WTjiw@mail.gmail.com>
 <20181214034053.23795-1-nbowler@draconx.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214034053.23795-1-nbowler@draconx.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Dec 13, 2018 at 10:40:53PM -0500, Nick Bowler wrote:
> Introduce two new test cases.  The first one greps xfs_fs.h to find
> any structure types possibly relevant to ioctls, then compares the
> structure layouts between 64-bit and 32-bit objects.  The goal is to
> ensure that any _new_ structure has the same characteristics on 32-bit
> versus 64-bit mode, ensuring a sane compat handler.  This requires a
> toolchain that can build both 64-bit and 32-bit objects, and hopefully
> works on non-x86 platforms with compat woes.
> 
> The whitelist was constructed by manually inspecting the current
> compat ioctl implementation.  The test validates that everything
> in the whitelist actually got found by the grepping as a sort of
> self-sanity check, but if older versions lacked some of these
> types then this might need tweaking a bit.
> 
> The second test validates that a well-known set of structures on x32
> crrectly match the ia32 or amd64 layouts as expected.  This requires
> a toolchain that can build for all three ABIs.
> 
> The idea is that new additions to the header where the structures
> differ in 32 and 64-bit x86 will be caught by the first test case
> and that will be sufficient to detect potential x32 problems too.
> 
> Signed-off-by: Nick Bowler <nbowler@draconx.ca>

I believe this effort was dropped. Respin?

  Luis
