Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 151AC29DF5
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 05:27:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7951304043
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 03:27:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mxjAuAIlCF8AFS1T (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 03:27:31 -0700 (PDT)
Date: Wed, 12 Aug 2015 18:27:28 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: generic/04[89] fail on XFS due to change in writeback code
Message-ID: <20150812102728.GF17933@dhcp-13-216.nay.redhat.com>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
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
To: xfs@oss.sgi.com
Cc: tj@kernel.org, axboe@fb.com, jack@suse.cz

On Wed, Aug 12, 2015 at 06:12:04PM +0800, Eryu Guan wrote:
> Hi all,
> 
> I've been seeing generic/04[89] fails on XFS since 4.2-rc1 from time to
> time, but the failure isn't reproduced on every test host. Recently I
> finally got a host that could reproduce the failure reliably.

[snip]

> 
> Attachments are my xfstests config file and host info requested by
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Oh, one more thing, I'm using xfsprogs 4.2.0-rc1 from upstream, but
xfsprogs version doesn't matter here, xfsprogs-3.2.2-1.el7 shipped with
RHEL7.1 makes no difference in my testing.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
