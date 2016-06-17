Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A54E7CA0
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 17:27:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B633304039
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 15:27:54 -0700 (PDT)
Received: from mail-oi0-f42.google.com (mail-oi0-f42.google.com
	[209.85.218.42]) by cuda.sgi.com with ESMTP id Q3oug9UrS36sYTsT
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2016 15:27:52 -0700 (PDT)
Received: by mail-oi0-f42.google.com with SMTP id u201so137021672oie.0
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 15:27:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160617203237.GD5893@omniknight.lm.intel.com>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
	<1466125419-17736-3-git-send-email-vishal.l.verma@intel.com>
	<20160617022606.GC11810@birch.djwong.org>
	<20160617192647.GC5893@omniknight.lm.intel.com>
	<20160617195345.GA5046@birch.djwong.org>
	<20160617203237.GD5893@omniknight.lm.intel.com>
Date: Fri, 17 Jun 2016 15:27:51 -0700
Message-ID: <CAPcyv4gEgcMxCkhPRbj3qvAqA6q1+Tuu0jVuuJSCysbuPmY=9w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] xfs: initial/partial support for badblocks
From: Dan Williams <dan.j.williams@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, XFS Developers <xfs@oss.sgi.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Jun 17, 2016 at 1:32 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
>> What happens if pmem signals a bad block and we try to read anyway?  I know
>> about the read-error-MCE thing, but what's the "more expensive" alternative?
>> CPU exception?
>
> MCE is the CPU exception, and is what we want to avoid at all costs, as
> it can cause the machine to crash.

The MCE being fatal vs recoverable is the difference between platforms
that must avoid badblocks vs those that can consume them and keep
going.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
