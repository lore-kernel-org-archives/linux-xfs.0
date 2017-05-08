Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751519AbdEHNkk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 May 2017 09:40:40 -0400
Date: Mon, 8 May 2017 09:40:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs: blocked task in xfs_buf_lock
Message-ID: <20170508134037.GC29840@bfoster.bfoster>
References: <000201d2c548$68fc5450$3af4fcf0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000201d2c548$68fc5450$3af4fcf0$@alibaba-inc.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?6JKL6ZuE5LyfKOiSi+WGsik=?= <xiongwei.jiang@alibaba-inc.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 05, 2017 at 10:36:33AM +0800, 蒋雄伟(蒋冲) wrote:
>  
> 
> While testing ceph cluster and using XFS as the underlying filesystem, I've
> seen xfs blocking tasks several times. 
> 
> Just as https://www.mail-archive.com/search?l=stable@vger.kernel.org
> <https://www.mail-archive.com/search?l=stable@vger.kernel.org&q=subject:%22x
> fs%3A+blocked+task+in+xfs_buf_lock%22&o=newest&f=1>
> &q=subject:%22xfs%3A+blocked+task+in+xfs_buf_lock%22&o=newest&f=1
> 
> And there is also another similar case
> http://oss.sgi.com/archives/xfs/2012-05/msg00307.html
> 
>  
> 
> These two cases was reported long time ago. Is it resolved  or is there any
> solution ?
> 

The above looks like a very old report without any resolution. I would
suggest to report your issue based on current observations rather than
rely on it looking similar to an old report. See the following for what
information is relevant to include when reporting a problem:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Note that the syslog and hung task output is particularly relevant here.

Brian

>  
> 
> Xiongwei Jiang
> 
