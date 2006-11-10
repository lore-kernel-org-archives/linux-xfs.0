Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 05:41:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAADf3aG009993
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 05:41:04 -0800
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.185])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6480D1CB302
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 05:16:33 -0800 (PST)
Received: by nf-out-0910.google.com with SMTP id x30so1076706nfb
        for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 05:16:32 -0800 (PST)
Message-ID: <bde600590611100516u7b8ca1bfs74d3cc8b78eb3520@mail.gmail.com>
Date: Fri, 10 Nov 2006 16:16:27 +0300
From: "Igor A. Valcov" <viaprog@gmail.com>
Subject: Re: XFS filesystem performance drop in kernels 2.6.16+
In-Reply-To: <Pine.LNX.4.61.0611101259490.6068@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bde600590611090930g3ab97aq3c76d7bca4ec267f@mail.gmail.com>
	 <4553F3C6.2030807@sandeen.net>
	 <Pine.LNX.4.61.0611101259490.6068@yvahk01.tjqt.qr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Below is a simplified version of the test program, and results of
testing different kernels/filesystems/mount options. The results are a
little different from the ones described in the initial post (this
time performance decreased "only" 2 times), but the general tendency
is clearly the same.


============ 2.6.19-rc5-git2 ============

mount -t xfs -o noatime,barrier /dev/sdc1 /mnt/disc

real    16m40.516s
user    0m17.989s
sys    9m36.320s

mount -t xfs -o noatime,nobarrier /dev/sdc1 /mnt/disc

real    15m40.212s
user    0m17.549s
sys    9m29.692s

mount -t ext3 -o noatime /dev/sdc1 /mnt/disc

real    49m44.728s
user    0m27.678s
sys    14m15.689s

============ 2.6.14.6 ============

mount -t xfs -o noatime /dev/sdc1 /mnt/disc

real    9m58.974s
user    0m17.373s
sys    8m4.850s

mount -t ext3 -o noatime /dev/sdc1 /mnt/disc

real    49m7.526s
user    0m26.278s
sys    12m37.627s

========================================

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define __BYTES        8192
#define __FILES        1000

char    buf [__BYTES];

int main ()
{
    char    fname [1024];
    int        nFiles [__FILES];
    int     f, i;

    /* Fill buf */
    for (i = 0; i < __BYTES; i++)
        buf [i] = i % 128;

    /* Create and open files */
    for (f = 0; f < __FILES; f++) {
        sprintf (fname, "/mnt/disc/storage/file-%d", f);
        nFiles [f] = open (fname, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    }

    for (i = 0; i < 262144; i++) {
        /* Write data to a big file */
        write (nFiles [0], buf, __BYTES);

        /* Write data to small files */
        for (f = 1; f < __FILES; f++)
            write (nFiles [f], &f, sizeof (f));
    }

    for (f = 0; f < __FILES; f++) {
        fsync (nFiles [f]);
        close (nFiles [f]);
    }

    return 0;
}

========================================

-- 
Igor A. Valcov
