Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51A287F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 12:12:28 -0600 (CST)
Date: Tue, 24 Feb 2015 12:12:27 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
Message-ID: <20150224181227.GZ25168@sgi.com>
References: <54EC958E.2000001@pythonanywhere.com>
	<20150224173305.GE4015@sgi.com>
	<54ECBC10.2090001@pythonanywhere.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54ECBC10.2090001@pythonanywhere.com>
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
To: Harry Percival <harry@pythonanywhere.com>
Cc: xfs@oss.sgi.com

Hi Harry,

On Tue, Feb 24, 2015 at 05:59:44PM +0000, Harry Percival wrote:
> Hi Ben,  thanks for replying.
> 
> We're using project quotas, and we'd be prepared to wipe the slate
> clean and start by saying there are no projects and no quotas at
> all, to start with.  Is there still no way of starting from scratch
> and avoiding that quotacheck?

You can use 'noquota' mount option or turn off accounting entirely and
delay the quotacheck until it's a more convenient time, but I'm afraid I
don't know of a way to avoid running the quotacheck altogether.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
