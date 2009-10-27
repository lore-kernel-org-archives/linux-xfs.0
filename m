Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9RFrKjN063882
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 10:53:21 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08D17AC00E
	for <linux-xfs@oss.sgi.com>; Tue, 27 Oct 2009 08:54:55 -0700 (PDT)
Message-ID: <4AE717CF.5020308@sgi.com>
Date: Tue, 27 Oct 2009 10:54:55 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore restoring MANY more files/dirs than expected, why?
References: <hc724t$tcn$1@ger.gmane.org>
In-Reply-To: <hc724t$tcn$1@ger.gmane.org>
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
To: mlueck@lueckdatasystems.com
Cc: linux-xfs@oss.sgi.com

On 10/27/2009 10:03 AM, Michael Lueck wrote:
> Greetings-
> 
> I recall last time I needed to restore A FILE from a XFS backup, MANY 
> MORE files/dirs got restored than expected. This time the same thing is 
> happening.
> 
> Screen dump of what I did:
> 
> =====================
> :/mnt/ext_backup/cirlnx01/20090510$ sudo xfsrestore -J -E -f 
> /mnt/ext_backup/cirlnx01/20090510/data -s shares/data -i -v verbose /srv
> [sudo] password for mdlueck:
> xfsrestore: using file dump (drive_simple) strategy
> xfsrestore: version 2.2.48 (dump format 3.0) - Running single-threaded
> xfsrestore: searching media for dump
> xfsrestore: examining media file 0
> xfsrestore: dump description:
> xfsrestore: hostname: cirlnx01
> xfsrestore: mount point: /srv
> xfsrestore: volume: /dev/sda9
> xfsrestore: session time: Sun May 10 18:07:35 2009
> xfsrestore: level: 0
> xfsrestore: session label: "data"
> xfsrestore: media label: ""
> xfsrestore: file system id: a43ad1fc-d88f-4d07-9f79-febffb48b9cb
> xfsrestore: session id: 13077fc1-21a4-4c14-8d95-cce194ef4f46
> xfsrestore: media id: c6a9ecb1-e776-4bf9-9537-bf1d61df5ac3
> xfsrestore: searching media for directory dump
> xfsrestore: reading directories
> xfsrestore: 7699 directories and 136729 entries processed
> xfsrestore: directory post-processing
> 
>  ========================== subtree selection dialog 
> ==========================
> 
> the following commands are available:
>     pwd
>     ls [ <path> ]
>     cd [ <path> ]
>     add [ <path> ]
>     delete [ <path> ]
>     extract
>     quit
>     help
> 
>  -> ls
>        472894529 kernel
>        939819197 orexx
>        805598566 3ware
>     *   67108992 shares/
>              131 samba
> 
>  -> cd shares
> 
>  -> ls
>        208673909 print
>        271069020 mdldist
>        402653312 stage
>        335544448 pdoxdata
>        268435584 netlogon
>     *  201326720 data/
>        134217856 apps
> 
>  -> cd data
> 
>  -> ls
>     *  738334798 RoadRunner/
>     *    6595075 .Trash-lobonca/
>     *  671534768 OldAbel/
>     *  337771329 AppData/
>     *   67679396 P/
>     *  604312789 AdamDesktop/
>     *  338912225 OldAdam2K/
>     *  609390639 OldAdam/
>     *  471772160 ME/
>     *  554166854 Icons/
>     *  201326742 W2KBoot-Build58.ISO
>     *  471986055 x-4Obie/
>     *  479802373 x-4Michael/
>     *  202289900 emobilereg.txt
>     *  201333984 Fla-to-Canada.txt
>     *  810634869 OldLazarus/
>     *  898326271 Reload/
>     *  336461836 Proj/
>     *  206164605 Photos/
>     *  135586077 Music/
>     *  471452033 Download/
> 
>  -> cd OldAbel
> 
>  -> ls
>     *  748264372 c/
> 
>  -> cd c
> 
>  -> ls
>     *  810634921 Documents and Settings/
> 
>  -> cd "Documents and Settings"
> 
>  -> ls
>     *  898287525 iserve/
> 
>  -> cd iserve
> 
>  -> ls
>     *  898339263 Thunderbird.zip
>     *  898339261 Firefox.zip
>     *  898339260 Mozilla.cmd
>     *  898339257 Thunderbird.cmd
>     *  898339256 Firefox.cmd
> 
>  -> add Thunderbird.zip
> 
>  -> extract
> 
>  --------------------------------- end dialog 
> ---------------------------------
> 
> xfsrestore: restoring non-directory files
> =====================
> 
> I am seeing the ENTIRE "data" backup restored, not just the one file I 
> specified to add.
> 
> Why is this? What am I doing incorrectly?

"-s shares/data" is the problem. See -i in the xfsrestore man page:

      Initially nothing is selected, except for those subtrees specified
      with -s command line options.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
