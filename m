Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729913AbeGQBx6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jul 2018 21:53:58 -0400
Date: Tue, 17 Jul 2018 11:23:45 +1000
From: Dave Chinner <dchinner@redhat.com>
Subject: Re: [LTP] [PATCH 4.17 00/67] 4.17.7-stable review
Message-ID: <20180717012345.GM20351@rh>
References: <20180716073443.294323458@linuxfoundation.org>
 <CA+G9fYtVSorLiG5cZdqtipy4XO1zr1HUZ4gH7tf_07m-B4HS1w@mail.gmail.com>
 <2078122506.33400530.1531776704409.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2078122506.33400530.1531776704409.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Stancek <jstancek@redhat.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Linus Torvalds <torvalds@linux-foundation.org>, ltp@lists.linux.it, open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, patches@kernelci.org, linux- stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, Guenter Roeck <linux@roeck-us.net>, linux-xfs@vger.kernel.org

[cc linux-xfs@vger.kernel.org]

Darrick, can you have a look over this mess while I'm afk?

-Dave.

On Mon, Jul 16, 2018 at 05:31:44PM -0400, Jan Stancek wrote:
> 
> 
> ----- Original Message -----
> > On 16 July 2018 at 13:04, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > wrote:
> > > This is the start of the stable review cycle for the 4.17.7 release.
> > > There are 67 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed Jul 18 07:34:11 UTC 2018.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.17.7-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >         linux-4.17.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > 
> > Results from Linaro’s test farm.
> > Regressions detected.
> > 
> > LTP syscalls failed test cases on all devices arm64, arm32 and x86_64,
> >  - creat08
> >  - open10
> 
> This is consequence of:
>   0fa3ecd87848 ("Fix up non-directory creation in SGID directories")
> 
> So likely cause of action here will be modifying both tests to not
> expect S_ISGID in scenario described in commit above.
> 
> [adding Dave Chinner]
> 
> @Dave: Does XFS need separate patch for problem described in commit
> 0fa3ecd87848? XFS doesn't appear to use inode_init_owner() function,
> both tests currently PASS the check for S_ISGID on file created by
> non-group member as of v4.18-rc5.
> 
> Regards,
> Jan
> 
> > 
> > Reported this bug internally on upstream Linux mainline week back.
> > Now this bug happening on 4.17, 4.14, 4.9 and 4.4
> > 
> > creat08 and open10 failed with this error,
> > TFAIL  : testdir.B.3132/setgid: Incorrect modes, setgid bit should be set
> > 
> > Test case description:
> > /*
> >  * NAME
> >  * creat08.c - Verifies that the group ID and setgid bit are
> >  *    set correctly when a new file is created.
> >  *    (ported from SPIE, section2/iosuite/creat5.c,
> >  *     by Airong Zhang <zhanga@us.ibm.com>)
> >  * CALLS
> >  * creat
> >  *
> >  * ALGORITHM
> >  * Create two directories, one with the group ID of this process
> >  * and the setgid bit not set, and the other with a group ID
> >  * other than that of this process and with the setgid bit set.
> >  * In each directory, create a file with and without the setgid
> >  * bit set in the creation modes. Verify that the modes and group
> >  * ID are correct on each of the 4 files.
> >  * As root, create a file with the setgid bit on in the
> >  * directory with the setgid bit.
> >  * This tests the SVID3 create group semantics.
> >  */
> > 
> > Block2 testing:
> > /*--------------------------------------------------------------*/
> > /* Block2: Create two files in testdir.B, one with the setgid   */
> > /*         bit set in the creation modes and the other without. */
> > /*    Both should inherit the group ID of the parent       */
> > /*    directory, group2.                                   */
> > /*--------------------------------------------------------------*/
> > 
> > 
> > Test results comparison on mainline versions,
> > https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/ltp-syscalls-tests/creat08
> > https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/ltp-syscalls-tests/open10
> > 
> > Test results comparison on 4.17 versions,
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-4.17-oe/tests/ltp-syscalls-tests/creat08
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-4.17-oe/tests/ltp-syscalls-tests/open10
> > 
> > Bug report link,
> > https://bugs.linaro.org/show_bug.cgi?id=3940
> > 
> > Summary
> > ------------------------------------------------------------------------
> > 
> > kernel: 4.17.7-rc1
> > git repo:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > git branch: linux-4.17.y
> > git commit: bc0bd9e05fa1e213c689620eb4cba825c03dcc4a
> > git describe: v4.17.6-68-gbc0bd9e05fa1
> > Test details:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-4.17-oe/build/v4.17.6-68-gbc0bd9e05fa1
> > 
> > Regressions (compared to build v4.17.6-67-g3b02b1fd1975)
> > ------------------------------------------------------------------------
> > 
> > LTP syscalls failed test cases on all devices,
> > 
> >  - creat08
> >  - open10
> > 
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
> > 
> > --
> > Mailing list info: https://lists.linux.it/listinfo/ltp
> > 
> 

-- 
Dave Chinner
dchinner@redhat.com
