Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 16:25:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9BNOkaG004666
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 16:24:48 -0700
Message-ID: <452D7D1A.1020405@sgi.com>
Date: Thu, 12 Oct 2006 09:24:10 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: GRIO in Linux XFS?
References: <CAEAF2308EEED149B26C2C164DFB20F4DDE78B@ALPMLVEM06.e2k.ad.ge.com> <Pine.LNX.4.61.0610112129060.9822@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0610112129060.9822@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Phetteplace, Thad (GE Healthcare, consultant)" <Thad.Phetteplace@ge.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Jan Engelhardt wrote:
>> what is the status of GRIO support in the Linux port of XFS?
>>     
griov2 supports XFS Linux/Irix on local and cluster volumes but it is 
not an open source
project. Please check this link for more information:
http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi/0650/bks/SGI_Admin/books/GRIO2_AG/sgi_html/ch01.html
>
> Called realtime volume.
> (http://en.wikipedia.org/wiki/XFS section 2.11)
>
>   
>> Also, if the answer is 'non existent', what is the recommended
>> alternative?  I've got an application that needs to stream a
>> huge amount of data to the harddrive without dropping any and
>> without blocking the sender.  We will be pushing the limits
>> of our high-end raid striped disks.  This seems the exactly
>> the type of thing GRIO was made for, but last I heard it was
>> missing from Linux XFS with no plans to add it.  Any change
>> in that?  I know I can get almost there with I/O priorities
>> and the RT features in 2.6... but its not quite the same
>> thing.
>>
>> Apologies if this has been beat to death here or elsewhere...
>> I've googled the heck out of this and rummaged around in the
>> list archives (as much as this fscking corporate firewall will
>> let me) with little result.  I'll gladly RTFM if someone can
>> point me at the right one.  :-/
>>
>> Feel free to CC me on replies, as I read the LKML in digest
>> format.
>>
>> Thanks,
>>
>> Thad Phetteplace
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     
>
> 	-`J'
>   
