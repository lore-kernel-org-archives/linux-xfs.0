Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q934K4sq135204 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 23:20:04 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id tjMtYw5HaWi7OEAs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 21:21:28 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q934LP71023844 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 21:21:27 -0700
Message-ID: <506BBD45.90308@tlinx.org>
Date: Tue, 02 Oct 2012 21:21:25 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
References: <11246457.6091377.1349236739598.JavaMail.root@redhat.com>
In-Reply-To: <11246457.6091377.1349236739598.JavaMail.root@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>



Nathan Scott wrote:
> Mmm, wasn't trying to pass judgement there - I'm sure the OpenSuSE
> package maintainer will take a patch to enable it in the spec file
> there if its not in place.
----
Wouldn't bet on it...

I tried to get them to NOT issue a disabling patch for default parallelism
in upstream sort, and they said not unless I could prove it wouldn't cause a
a hang in their build process (when it was first implemented, their algorithm
had a few problems due to default buffer sizes on linux), but that was 2 years
ago and O.Suse still won't enable it - but you can specify that you want
parallel sort with every invocation -- which doesn't help for 3rd party progs
that just call sort (like updatedb) -- unless you modify them as well..

They also don't support build packages via source on a opensuse installation ---
as it has "superfluous" packages installed, and they don't want to test for
interactions anymore.

I felt even if they wanted a cleanroom for production -- they could still do
rpmbuilds with a a clean-distro devel install as a test step that things
worked together, but it seems like they are moving away from supporting direct
development or building of packages except via a special cleaned root.

Disappointing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
