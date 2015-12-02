Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED7A47F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 14:10:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C725AC001
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 12:10:50 -0800 (PST)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com
	[209.85.192.43]) by cuda.sgi.com with ESMTP id 6MwJJOMjimYacQmO
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 12:10:48 -0800 (PST)
Received: by qgcc31 with SMTP id c31so42941947qgc.3
	for <xfs@oss.sgi.com>; Wed, 02 Dec 2015 12:10:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151202183438.GA1319@linux.intel.com>
References: <20151202183438.GA1319@linux.intel.com>
Date: Wed, 2 Dec 2015 12:10:48 -0800
Message-ID: <CAA9_cmdxh6RE+BbXf3YTef25LFrQDP7bBHMvRoQQJ+mEQ_2vLw@mail.gmail.com>
Subject: Re: xfstests failures with xfs, dax and v4.4-rc3
From: Dan Williams <dan.j.williams@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>

On Wed, Dec 2, 2015 at 10:34 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> I'm hitting a few more test failures in my testing setup with v4.4-rc3, xfs
> and DAX.  My test setup is a pair of 4GiB PMEM partitions in a KVM virtual
> machine.  Here are the failures:
>

Is this a passing test with a v4.3 baseline?  git bisect?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
