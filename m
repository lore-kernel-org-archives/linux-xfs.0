Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8B84B7CA0
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 20:14:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B1CB304039
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 18:14:54 -0700 (PDT)
Received: from mail-oi0-f50.google.com (mail-oi0-f50.google.com
	[209.85.218.50]) by cuda.sgi.com with ESMTP id jemKORhGBXTGC51t
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2016 18:14:48 -0700 (PDT)
Received: by mail-oi0-f50.google.com with SMTP id r2so95902884oih.2
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 18:14:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160623232446.GA12670@dastard>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Jun 2016 18:14:47 -0700
Message-ID: <CAPcyv4iWVyJ3vb+_dtehGRxT9WXwAxNXoDMNeNtxO+=njHNAhg@mail.gmail.com>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Christoph Hellwig <hch@lst.de>, XFS Developers <xfs@oss.sgi.com>

On Thu, Jun 23, 2016 at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jun 22, 2016 at 05:27:08PM +0200, Christoph Hellwig wrote:
>> The last patch is what started the series:  XFS currently uses the
>> direct I/O locking strategy for DAX because DAX was overloaded onto
>> the direct I/O path.  For XFS this means that we only take a shared
>> inode lock instead of the normal exclusive one for writes IFF they
>> are properly aligned.  While this is fine for O_DIRECT which requires
>> explicit opt-in from the application it's not fine for DAX where we'll
>> suddenly lose expected and required synchronization of the file system
>> happens to use DAX undeneath.
>
> Except we did that *intentionally* - by definition there is no
> cache to bypass with DAX and so all IO is "direct". That, combined
> with the fact that all Linux filesystems except XFS break the POSIX
> exclusive writer rule you are quoting to begin with, it seemed
> pointless to enforce it for DAX....

If we're going to be strict about POSIX fsync() semantics we should be
strict about this exclusive write semantic.  In other words why is it
ok to loosen one and not the other, if application compatibility is
the concern?

>
> So, before taking any patches to change that behaviour in XFS, a
> wider discussion about the policy needs to be had. I don't think
> we should care about POSIX here - if you have an application that
> needs this serialisation, turn off DAX.

s/needs this serialisation/needs the kernel to flush cpu cache/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
