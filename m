Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0BBAE7F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 14:25:22 -0600 (CST)
Date: Fri, 22 Feb 2013 14:25:18 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: dozens of xfsaild threads
Message-ID: <20130222202518.GX22182@sgi.com>
References: <CAGot=x-aiATNxBty7FXxV_td7Wx1_Mh8c8ta=mr4hpHxtmv6Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGot=x-aiATNxBty7FXxV_td7Wx1_Mh8c8ta=mr4hpHxtmv6Nw@mail.gmail.com>
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
To: Erik Knight <kutuzof@gmail.com>
Cc: xfs@oss.sgi.com

Hi Erik,

On Fri, Feb 22, 2013 at 02:04:17PM +0100, Erik Knight wrote:
> We've recently noticed that our system is experiencing extreme performance
> problems when running large workloads. The problem seems to come from
> excessive System CPU time. Specifically dozens of xfsaild threads. We used
> to have SSD drives but recently switched to HDD, so some of us are thinking
> that there may be a configuration issue within XFS that is optimized for
> SSD but performs terribly slow on HDD.
> 
> Can anyone explain what these threads do, what would cause so many of them
> to be running simultaneously or consume so much CPU?

AIL stands for Active Item List.  These guys sync metadata which has been
logged to its final location on disk.  You'll have one daemon per filesystem.  

If you have a very metadata intensive workload they could get a workout.  It
would help to know a bit more about your workload and configuration.  Can you
provide the relevant information listed here?

http://www.xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
